import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ActionConfirm.dart';
import 'package:xpens/screens/home/components/addItem.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';

import '../../../services/database.dart';

import 'searchItems.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  String searchKey = "";
  void setSearchKey(val) {
    setState(() {
      searchKey = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;

    double ht = MediaQuery.of(context).size.height;
    UserInfoProvider userInfo = Provider.of<UserInfoProvider>(context);
    User? user = Provider.of<User?>(context);
    List list = userInfo.items;
    if (searchKey != "") {
      list = list
          .where((name) => name.toLowerCase().contains(searchKey.toLowerCase()))
          .toList();
    }
    print(searchKey);
    return Stack(
      children: [
        ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: list.length + 1,
            itemBuilder: (BuildContext context, int i) {
              if (i == 0) {
                return ItemsSearchWidget(
                  changeSearchKey: setSearchKey,
                  searchKey: searchKey,
                );
              }
              return list[i - 1] == "Other"
                  ? Container()
                  : Padding(
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
                              Text(
                                list[i - 1],
                                style: const TextStyle(fontSize: 16),
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
                                            delete: () async {
                                              await DatabaseService(
                                                      uid: user!.uid)
                                                  .updateItemsArray(
                                                add: false,
                                                item: list[i - 1],
                                              );
                                              Navigator.pop(context);
                                            },
                                            title: "Delete Item",
                                            msg:
                                                "Press Confirm to delete ${list[i - 1]}  from the List.",
                                          );
                                        });
                                    FocusManager.instance.primaryFocus!
                                        .unfocus();
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          )),
                    );
            }),
        AddItemWidget(
            icon: Icons.add,
            btnPostionBottom: 10,
            postionBottom: 0,
            btnPositionRight: 10,
            tag: 'itemName',
            addFunc: (name) async {
              name = name.substring(0, 1).toUpperCase() + name.substring(1);
              await DatabaseService(uid: user!.uid).updateItemsArray(
                add: true,
                item: name,
              );
            })
      ],
    );
  }
}
