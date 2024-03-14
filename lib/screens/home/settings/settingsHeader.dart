import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/shared/constants.dart';

import '../../../services/providers/UserInfoProvider.dart';
import 'Profile/Profile.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    User? user = Provider.of<User?>(context);
    var userInfo = Provider.of<UserInfoProvider>(context);
    return Row(
      children: [
        SizedBox(
          width: wt * 0.06,
        ),
        Container(
          decoration: const BoxDecoration(
              color: secondaryAppColor, shape: BoxShape.circle),
          height: ht * 0.095,
          width: ht * 0.095,
        ),
        SizedBox(
          width: wt * 0.04,
        ),
        SizedBox(
          height: ht * 0.1,
          // color: Colors.amber,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: ht * 0.04,
              // ),
              Text(
                userInfo.userName,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(
                height: ht * 0.015,
              ),
              Text(
                userInfo.phone,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                user!.email ?? "",
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          ),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.fromLTRB(0, ht * 0.005, wt * 0.02, 0),
          alignment: Alignment.topCenter,
          // color: Colors.amber,
          child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => Profile(
                              name: userInfo.userName,
                              phoneNumber: userInfo.phone,
                            )));
              },
              child: const Icon(
                Icons.edit,
                color: Color.fromARGB(255, 192, 192, 192),
              )),
        ),
        // SizedBox(
        //   width: wt * 0.03,
        // ),
      ],
    );
  }
}
