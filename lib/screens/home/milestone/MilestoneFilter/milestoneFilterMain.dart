import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xpens/screens/home/milestone/MilestoneFilter/PeriodFilter.dart';
import 'package:xpens/shared/constants.dart';

import '../MilestoneGetx.dart';

class MilestonesFilterMain extends StatefulWidget {
  final bool filterEnabled;
  final Function dissableFilter;

  const MilestonesFilterMain({
    super.key,
    required this.filterEnabled,
    required this.dissableFilter,
  });
  @override
  State<MilestonesFilterMain> createState() => _MilestonesFilterMainState();
}

class _MilestonesFilterMainState extends State<MilestonesFilterMain> {
  final controller = Get.put(MilestoneFilterController());
  @override
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return SizedBox(
      height: ht,
      child: Stack(
        children: [
          widget.filterEnabled
              ? InkWell(
                  onTap: () => widget.dissableFilter(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.fastOutSlowIn,
                    color: const Color.fromARGB(144, 196, 196, 196),
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              // padding: EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
              ),
              height: widget.filterEnabled ? 400 : 0,
              width: wt,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ListView(children: [
                      PeriodFilterAccordion(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: wt * 0.3,
                            height: ht * 0.05,
                            child: OutlinedButton(
                              // style: buttonDecoration,
                              onPressed: () => controller.clearFilter(),
                              child: const Center(
                                  child: Text(
                                "Clear",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: wt * 0.3,
                            height: ht * 0.05,
                            child: ElevatedButton(
                              style: buttonDecoration,
                              onPressed: () {
                                controller
                                    .setMainperiodList(controller.periodList);
                                widget.dissableFilter();
                              },
                              child: const Center(
                                  child: Text(
                                "Apply",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          )
                        ],
                      )
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, ht * 0.02, wt * 0.08, 0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () => widget.dissableFilter(),
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
