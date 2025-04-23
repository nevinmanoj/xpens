import 'package:get/get.dart';
import 'package:xpens/shared/dataModals/dbModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';

class MilestoneFilterController extends GetxController {
  List<Period> periodList = [...Period.values];
  List<Period> mainPeriodList = [...Period.values];

  void clearFilter() {
    periodList = [...Period.values];
    mainPeriodList = [...Period.values];
    update();
  }

  void modifyPeriodList(Period p) {
    if (periodList.contains(p)) {
      periodList.remove(p);
    } else {
      periodList.add(p);
    }
    update();
  }

  void setMainperiodList(List<Period> newList) {
    mainPeriodList = newList;
    update();
  }
}

class MilestonePopupController extends GetxController {
  Milestone? ms;
  setMS(Milestone? m) {
    ms = m;
    update();
  }
}
