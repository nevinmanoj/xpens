import 'package:get/get.dart';
import 'package:xpens/shared/dataModals/MilestoneModal.dart';
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

  bool showAdd = false;
  String newval = "";

  setMS(Milestone? m) {
    ms = m;
    showAdd = false;
    newval = "";
    update();
  }

  setshowadd(bool val) {
    showAdd = val;
    update();
  }

  setnewval(String val) {
    newval = val;
    update();
  }
}
