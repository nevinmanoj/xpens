import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xpens/shared/Db.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';
import 'package:xpens/shared/dataModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';
import 'package:xpens/shared/utils/getDateTimesFromPeriod.dart';

class MilestoneDatabaseService {
  final String uid;
  MilestoneDatabaseService({required this.uid});

  Future addMilestoneTemplate({required MilestoneTemplate item}) async {
    final docRef = await FirebaseFirestore.instance
        .collection('$db/$uid/milestone-templates')
        .doc();
    item.templateId = docRef.id;
    docRef.set(item.toJson(), SetOptions(merge: true));
  }

  Future editMilestone({required Milestone item}) async {
    // check if we need to move to complete
    if (item.currentVal != null && item.endVal != null) {
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
    if (item.currentVal != null && item.endVal != null) {
      if (item.currentVal! >= item.endVal!) {
        item.currentStatus = Status.closed;
      }
    }

    await FirebaseFirestore.instance
        .collection('$db/$uid/milestones')
        .doc(item.selfId)
        .set(item.toJson(), SetOptions(merge: true));
  }

  Future editMilestoneTemplate({
    required MilestoneTemplate item,
    required String id,
  }) async {
    await FirebaseFirestore.instance
        .collection('$db/$uid/milestone-templates')
        .doc(id)
        .set(item.toJson(), SetOptions(merge: true));
  }

  Future deleteMilestone({required selfID}) async {
    FirebaseFirestore.instance
        .collection('$db/$uid/milestones')
        .doc(selfID)
        .delete();
  }

  Future deleteTemplateandCurrentMilestone({required String templateid}) async {
    try {
      await FirebaseFirestore.instance
          .collection('$db/$uid/milestone-templates')
          .doc(templateid)
          .delete();
      //get not closed ms of template
      final milestones = await FirebaseFirestore.instance
          .collection('$db/$uid/milestones')
          .where("templateID", isEqualTo: templateid)
          .where("currentStatus", isNotEqualTo: "closed")
          .get();

      for (var ms in milestones.docs) {
        deleteMilestone(selfID: ms.id);
      }
    } catch (e) {
      print(e);
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
            isNextPeriod: skipCurrent),
        title: template.title,
        endVal: template.endVal,
        currentVal: template.endVal != null ? 0 : null,
        currentStatus: skipCurrent ? Status.upcoming : Status.active,
        templateID: templateID,
        skipFirst: template.skipFirst);
    await FirebaseFirestore.instance
        .collection('$db/$uid/milestones')
        .doc()
        .set(ms.toJson(), SetOptions(merge: true));
  }
}
