import 'package:xpens/shared/dataModals/dbModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';

List<Milestone> applyMSFilter(
    {required List<Milestone> data,
    required List<MilestoneTemplate> templates,
    required List periodList,
    required List groups,
    required Status currentStatus}) {
  //filter status
  data = data.where((e) => currentStatus == e.currentStatus).toList();
  //find parent and filter periods
  data = data.where((e) => periodList.contains(e.period)).toList();
  if (groups.isNotEmpty) {
    data = data.where((e) => groups.contains(e.group)).toList();
  }

  //TODO:do order by expire time, and more
  return data;
}
