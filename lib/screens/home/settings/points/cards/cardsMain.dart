import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/database.dart';

import '../../../../../services/providers/UserInfoProvider.dart';

import '../../../components/items/addItem.dart';
import '../../../components/items/deleteItem.dart';

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
    User? user = Provider.of<User?>(context);
    return Stack(
      children: [
        ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: userInfo.cards.length,
            itemBuilder: (BuildContext context, int i) {
              return Padding(
                padding:
                    EdgeInsets.fromLTRB(wt * 0.05, ht * 0.01, wt * 0.05, 0),
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
                        Text(
                          userInfo.cards[i],
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        userInfo.cards[i] == "Other"
                            ? Container()
                            : IconButton(

                                // onPressed:null,
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (_) {
                                        return DeleteItem(
                                          tag: "Card",
                                          deleteFunc: () {},
                                          itemName: userInfo.cards[i],
                                        );
                                      });
                                  FocusManager.instance.primaryFocus!.unfocus();
                                },
                                icon: const Icon(Icons.delete))
                      ],
                    )),
              );
            }),
        AddItemWidget(
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
