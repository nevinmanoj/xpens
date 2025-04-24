import 'package:get/get.dart';
import 'package:xpens/shared/dataModals/dbModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';

class MilestoneFilterController extends GetxController {
  List<Period> periodList = [...Period.values];
  // List<Period> mainPeriodList = [...Period.values];
  List<String> groups = [];
  // List<String> mainGroups = [];

  void clearFilter() {
    periodList = [...Period.values];
    // mainPeriodList = [...Period.values];
    groups = [];
    // mainGroups = [];
    update();
  }

  void modifyPeriodList(Period p) {
    if (periodList.contains(p)) {
      periodList.remove(p);
    } else {
      periodList.add(p);
    }
    // mainPeriodList = periodList;
    update();
  }

  void modifyGroupsList(String grp) {
    if (groups.contains(grp)) {
      groups.remove(grp);
    } else {
      groups.add(grp);
    }
    update();
  }

  // void setMainList() {
  //   mainPeriodList = periodList;
  //   mainGroups = groups;
  //   update();
  // }
}

class MilestonePopupController extends GetxController {
  Milestone? ms;
  setMS(Milestone? m) {
    ms = m;
    update();
  }
}
