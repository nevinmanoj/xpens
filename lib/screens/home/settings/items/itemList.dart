import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/settings/items/deleteItem.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';

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
      padding: EdgeInsets.fromLTRB(0, ht * 0.1, 0, 0),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: userInfo.items.length,
          itemBuilder: (BuildContext context, int i) {
            return Padding(
              padding: EdgeInsets.fromLTRB(wt * 0.05, ht * 0.01, wt * 0.05, 0),
              child: Container(
                  padding: EdgeInsets.fromLTRB(wt * 0.05, 0, 0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
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
                        userInfo.items[i],
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      userInfo.items[i] == "Other"
                          ? Container()
                          : IconButton(

                              // onPressed:null,
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return DeleteItem(
                                        itemName: userInfo.items[i],
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
