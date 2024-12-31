import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/settings/items/itemList.dart';
import 'package:xpens/screens/home/settings/defaults/defaultMain.dart';
import 'package:xpens/screens/home/settings/points/PointsMain.dart';
import '../../../services/auth.dart';
import '../../../services/providers/UserInfoProvider.dart';
import '../../../shared/constants.dart';
import 'Trash/TrashMain.dart';
import 'billSplit/billSplitMain.dart';
import 'dev/devDash.dart';
import 'DownloadStatement/DownloadStatementMain.dart';
import 'GroupReport/GroupReportMain.dart';
import 'settingsHeader.dart';
import 'settingsMenuItem.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var userInfo = Provider.of<UserInfoProvider>(context);

    List items = [
      {
        "icon": FontAwesome.file_arrow_down_solid,
        "title": "Download Statement",
        "onTap": () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const DownloadStatementMain()));
        }
      },
      {
        "icon": Icons.lock_reset,
        "title": "Reset Password",
        "onTap": () {
          var email = user!.email;
          if (email != null) AuthSerivice().Passwordreset(email, context);
        }
      },
      {
        "icon": Icons.sell,
        "title": "Group Summary",
        "onTap": () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const GroupReportMain()));
        }
      },
      {
        "icon": Icons.logout,
        "title": "Logout",
        "onTap": () => AuthSerivice().signOut(),
      },
      {
        "icon": Icons.star_rate,
        "title": "Credit Points Usage",
        "onTap": () => Navigator.push(context,
            CupertinoPageRoute(builder: (context) => const PointsMain())),
      },
      {
        "icon": Icons.auto_delete,
        "title": "Trash",
        "onTap": () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => const TrashMain()));
        }
      },
      // {
      //   "icon": IonIcons.receipt,
      //   "title": "Bill Split",
      //   "onTap": () {
      //     Navigator.push(context,
      //         CupertinoPageRoute(builder: (context) => const BillSplitMain()));
      //   }
      // },
      {
        "icon": Icons.tune,
        "title": "Defaults",
        "onTap": () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => const Defaults()));
        }
      },
      {
        "icon": Icons.category,
        "title": "Item List",
        "onTap": () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => const ItemList()));
        }
      },
    ];
    if (userInfo.isDev) {
      items.add({
        "icon": Icons.logo_dev,
        "title": "Dev Dash",
        "onTap": () => Navigator.push(
            context, CupertinoPageRoute(builder: (context) => const DevDash())),
      });
    }
    return SizedBox(
      width: wt,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: primaryAppColor,
              width: wt,
              height: ht * 0.15,
              child: const SettingsHeader(),
            ),
            GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              children: [
                for (var item in items)
                  SettingsItem(
                    icon: item['icon'],
                    title: item['title'],
                    onTap: item['onTap'],
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
