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

  Future editMilestoneorTemplate(
      {required item, required String id, required bool isTemplate}) async {
    await FirebaseFirestore.instance
        .collection(
            '$db/$uid/' + (isTemplate ? 'milestone-templates' : 'milestones'))
        .doc(id)
        .set(item.toJson(), SetOptions(merge: true));
  }

  Future deleteMilestoneorTemplate(
      {required bool isTemplate, required String id}) async {
    FirebaseFirestore.instance
        .collection(
            '$db/$uid/' + (isTemplate ? 'milestone-templates' : 'milestones'))
        .doc(id)
        .delete();
  }

  Future addMilestone(
      {required MilestoneTemplate template,
      required bool skipCurrent,
      required String templateID}) async {
    Milestone ms = Milestone(
        selfId: "Place holder",
        dateRange: getDateTimesFromPeriod(
            p: template.period,
            date: DateTime.now(),
            isNextPeriod: skipCurrent),
        title: template.title,
        endVal: template.endVal,
        currentVal: 0,
        currentStatus: skipCurrent ? Status.upcoming : Status.active,
        templateID: templateID);
    await FirebaseFirestore.instance
        .collection('$db/$uid/milestones')
        .doc()
        .set(ms.toJson(), SetOptions(merge: true));
  }
}
