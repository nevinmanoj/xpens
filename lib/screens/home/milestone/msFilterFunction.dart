import 'package:xpens/shared/dataModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';

List<Milestone> applyMSFilter(
    {required List<Milestone> data,
    required List<MilestoneTemplate> templates,
    required List periodList,
    required List statusList}) {
  //filter status
  data = data.where((e) => statusList.contains(e.currentStatus)).toList();
  //find parent and filter periods
  data = data
      .where((milestone) => periodList.contains(templates
          .firstWhere((template) => template.templateId == milestone.templateID)
          .period))
      .toList();
  //TODO:do order by expire time, and more
  return data;
}
