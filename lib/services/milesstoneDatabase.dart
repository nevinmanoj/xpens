import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xpens/shared/Db.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';
import 'package:xpens/shared/dataModals/dbModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';
import 'package:xpens/shared/dataModals/subModals/MilestoneValue.dart';
import 'package:xpens/shared/utils/getDateTimesFromPeriod.dart';

class MilestoneDatabaseService {
  final String uid;
  MilestoneDatabaseService({required this.uid});

  Future addMilestoneTemplate({required MilestoneTemplate item}) async {
    await FirebaseFirestore.instance
        .collection('$db/$uid/milestone-templates')
        .doc()
        .set(item.toJson(), SetOptions(merge: true));
  }

  Future editMilestone({required Milestone item}) async {
    // check if we need to move to complete

    if (item.currentVal == null && item.endVal != null) {
      item.currentVal = 0;
    }

    if (item.currentVal != null && item.endVal != null) {
      double sum = 0;
      for (MilestoneValue value in item.values) {
        sum += value.value;
      }
      item.currentVal = sum;
      if (item.currentVal! >= item.endVal!) {
        item.currentStatus = Status.closed;
      }
    }

    await FirebaseFirestore.instance
        .collection('$db/$uid/milestones')
        .doc(item.selfId)
        .set(item.toJson(), SetOptions(merge: true));
  }

  Future editAllMilestonesOftemplate(
      {required Milestone item, required MilestoneTemplate template}) async {
    await editMilestoneTemplate(item: template);
    var msdata = await FirebaseFirestore.instance
        .collection("$db/$uid/milestones")
        .where("templateID", isEqualTo: template.templateId)
        .get()
        .then((value) => value.docs);
    for (var ms in msdata) {
      Milestone msobj = Milestone.fromJson(ms);
      msobj.title = template.title;
      msobj.endVal = template.endVal;
      if (msobj.selfId == item.selfId) {
        msobj.currentVal = item.currentVal;
      }
      editMilestone(item: msobj);
    }
  }

  Future editMilestoneTemplate({
    required MilestoneTemplate item,
  }) async {
    var mstdoc = await FirebaseFirestore.instance
        .collection('$db/$uid/milestone-templates')
        .doc(item.templateId)
        .get();
    if (mstdoc.data() != null) {
      item.addedDate =
          DateTime.fromMillisecondsSinceEpoch(mstdoc.data()!["addedDate"]);
    }

    await FirebaseFirestore.instance
        .collection('$db/$uid/milestone-templates')
        .doc(item.templateId)
        .set(item.toJson(), SetOptions(merge: true));
  }

  Future deleteMilestone({required selfID}) async {
    FirebaseFirestore.instance
        .collection('$db/$uid/milestones')
        .doc(selfID)
        .delete();
  }

  Future deleteTemplateandCurrentMilestone(
      {required String templateid, required Status status}) async {
    try {
      await FirebaseFirestore.instance
          .collection('$db/$uid/milestone-templates')
          .doc(templateid)
          .delete();
      //get all ms of template
      final milestones = await FirebaseFirestore.instance
          .collection('$db/$uid/milestones')
          .where("templateID", isEqualTo: templateid)
          .get();

      for (var ms in milestones.docs) {
        if ((ms.data()["currentStatus"] == "closed") ||
            (ms.data()["currentStatus"] == "active" &&
                status == Status.upcoming)) {
          Milestone item = Milestone.fromJson(ms);
          item.isOrphan = true;
          editMilestone(item: item);
        } else {
          deleteMilestone(selfID: ms.id);
        }
      }
    } catch (e) {
      print("method: deleteTemplateandCurrentMilestone $e");
    }
  }

  Future addMilestone(
      {required MilestoneTemplate template,
      required bool skipCurrent,
      required String templateID}) async {
    Milestone ms = Milestone(
        period: template.period,
        selfId: "Place holder",
        dateRange: getDateTimesFromPeriod(
            p: template.period,
            date: DateTime.now(),
            offset: skipCurrent ? 1 : 0),
        title: template.title,
        endVal: template.endVal,
        isOrphan: false,
        currentVal: template.endVal != null ? 0.0 : null,
        currentStatus: skipCurrent ? Status.upcoming : Status.active,
        templateID: templateID,
        skipFirst: template.skipFirst,
        values: <MilestoneValue>[],
        idCount: 0);
    await FirebaseFirestore.instance
        .collection('$db/$uid/milestones')
        .doc()
        .set(ms.toJson(), SetOptions(merge: true));
  }
}
