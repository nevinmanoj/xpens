import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/settings/points/cards/cardsPointsFunc.dart';
import 'package:xpens/services/database.dart';

import '../../../../../services/providers/UserInfoProvider.dart';

import '../../../components/ActionConfirm.dart';
import '../../../components/addItem.dart';
import 'cardsExpanded.dart';

class CardsMain extends StatefulWidget {
  const CardsMain({super.key});

  @override
  State<CardsMain> createState() => _CardsMainState();
}

class _CardsMainState extends State<CardsMain> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    UserInfoProvider userInfo = Provider.of<UserInfoProvider>(context);
    List<double> sums = [];
    for (var card in userInfo.cards) {
      if (card != "Other") {
        sums.add(calcCardpoints(
            start: null,
            end: DateTime.now(),
            data: userInfo.pointDocs,
            card: card));
      }
    }
    User? user = Provider.of<User?>(context);
    return Stack(
      children: [
        ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: userInfo.cards.length,
            itemBuilder: (BuildContext context, int i) {
              return userInfo.cards[i] == "Other"
                  ? Container()
                  : InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return ExpandCard(
                                card: userInfo.cards[i],
                                sum: sums[i],
                              );
                            });
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            wt * 0.05, ht * 0.01, wt * 0.05, 0),
                        child: Container(
                            padding: EdgeInsets.fromLTRB(wt * 0.05, 0, 0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 1,
                                    color: Colors.grey,
                                    offset: Offset(0.0, 2))
                              ],
                              color: Colors.white,
                            ),
                            width: wt,
                            height: ht * 0.075,
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userInfo.cards[i],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "${sums[i].toInt().toString()} points spent",
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Color.fromARGB(
                                              255, 143, 134, 134)),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(

                                    // onPressed:null,
                                    onPressed: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (_) {
                                            return ActionConfirm(
                                              cancel: () {
                                                Navigator.pop(context);
                                              },
                                              confirm: () async {
                                                await DatabaseService(
                                                        uid: user!.uid)
                                                    .updateCardsArray(
                                                  add: false,
                                                  card: userInfo.cards[i],
                                                );
                                                Navigator.pop(context);
                                              },
                                              title: "Delete Card",
                                              msg:
                                                  "Press Confirm to delete ${userInfo.cards[i]}  from the List.",
                                            );
                                          });
                                      FocusManager.instance.primaryFocus!
                                          .unfocus();
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            )),
                      ),
                    );
            }),
        AddItemWidget(
          icon: Icons.add_card,
          btnPostionBottom: 10,
          postionBottom: 0,
          btnPositionRight: 10,
          addFunc: (val) async {
            await DatabaseService(uid: user!.uid)
                .updateCardsArray(add: true, card: val);
          },
          tag: 'card',
        )
      ],
    );
  }
}
