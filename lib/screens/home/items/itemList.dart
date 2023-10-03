import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/items/deleteItem.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';

import 'addItem.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;

    double ht = MediaQuery.of(context).size.height;
    UserInfoProvider userInfo = Provider.of<UserInfoProvider>(context);

    return Container(
      // padding: EdgeInsets.fromLTRB(wt * 0.1, ht * 0.1, wt * 0.1, 0),
      // margin: EdgeInsets.fromLTRB(wt * 0.1, 0, wt * 0.1, 0),
      // padding: EdgeInsets.fromLTRB(0, ht * 0.1, 0, 0),
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: userInfo.items.length + 1,
          itemBuilder: (BuildContext context, int i) {
            if (i == 0) {
              return NewItemsAddwidget();
            }
            return Padding(
              padding: EdgeInsets.fromLTRB(wt * 0.05, ht * 0.01, wt * 0.05, 0),
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
                        userInfo.items[i - 1],
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      userInfo.items[i - 1] == "Other"
                          ? Container()
                          : IconButton(

                              // onPressed:null,
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return DeleteItem(
                                        itemName: userInfo.items[i - 1],
                                      );
                                    });
                                FocusManager.instance.primaryFocus!.unfocus();
                              },
                              icon: const Icon(Icons.delete))
                    ],
                  )),
            );
          }),
    );
  }
}
