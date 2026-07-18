import 'package:flutter/material.dart';
import 'package:xpens/screens/home/settings/creditPayments/cards/cardsMain.dart';
import 'package:xpens/shared/constants.dart';

List<String> menuoptions = ["Summary", "List", "Cards"];

class CreditPaymentsMain extends StatefulWidget {
  const CreditPaymentsMain({super.key});

  @override
  State<CreditPaymentsMain> createState() => _CreditPaymentsMainState();
}

class _CreditPaymentsMainState extends State<CreditPaymentsMain> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: primaryAppColor,
            bottom: TabBar(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              indicatorColor: secondaryAppColor,
              labelColor: secondaryAppColor,
              unselectedLabelColor: const Color(0xff778585),
              tabs: menuoptions
                  .map((e) => Tab(
                        child: Text(
                          e,
                          style: TextStyle(fontSize: wt * 0.04),
                        ),
                      ))
                  .toList(),
            ),
          ),
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              Container(),
              Container(),
              CardsMain(),
            ],
          ),
        ));
  }
}
