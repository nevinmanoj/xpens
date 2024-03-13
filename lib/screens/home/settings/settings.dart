import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/settings/points/PointsMain.dart';
import '../../../services/auth.dart';
import '../../../services/providers/UserInfoProvider.dart';
import '../../../shared/constants.dart';
import 'Trash/TrashMain.dart';
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
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    var userInfo = Provider.of<UserInfoProvider>(context);

    List items = [
      {
        "icon": FontAwesome.file_arrow_down,
        "title": "Download Statement",
        "onTap": () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => DownloadStatementMain()));
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
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => GroupReportMain()));
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
        "onTap": () => Navigator.push(
            context, CupertinoPageRoute(builder: (context) => PointsMain())),
      },
      {
        "icon": Icons.auto_delete,
        "title": "Trash",
        "onTap": () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => TrashMain()));
        }
      },
    ];
    if (userInfo.isDev) {
      items.add({
        "icon": Icons.logo_dev,
        "title": "Dev Dash",
        "onTap": () => Navigator.push(
            context, CupertinoPageRoute(builder: (context) => DevDash())),
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
              physics: NeverScrollableScrollPhysics(),
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

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double wt = MediaQuery.of(context).size.width;
//     double ht = MediaQuery.of(context).size.height;
//     FirebaseAuth _auth = FirebaseAuth.instance;
//     User? user = _auth.currentUser;
//     var userInfo = Provider.of<UserInfoProvider>(context);
//     return Column(
//       children: [
//         InkWell(
//           onTap: () {
//             Navigator.push(
//                 context,
//                 CupertinoPageRoute(
//                     builder: (context) => Profile(
//                           name: userInfo.userName,
//                           phoneNumber: userInfo.phone,
//                         )));
//           },
//           child: Container(
//             color: Colors.grey[300],
//             width: wt,
//             height: ht * 0.06,
//             child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(wt * 0.03, 0, 0, 0),
//                   child: Text(
//                     "Profile",
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 )),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.fromLTRB(wt * 0.01, ht * 0.005, wt * 0.01, 0),
//           child: InkWell(
//             onTap: () async {
//               var email = user!.email;
//               if (email != null) AuthSerivice().Passwordreset(email, context);
//             },
//             child: Container(
//               // decoration: ,
//               color: Colors.grey[300],
//               width: wt,
//               height: ht * 0.06,
//               child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                       padding: EdgeInsets.fromLTRB(wt * 0.03, 0, 0, 0),
//                       child: const Icon(Icons.lock_reset))),
//             ),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.fromLTRB(wt * 0.01, ht * 0.005, wt * 0.01, 0),
//           child: InkWell(
//             onTap: () async => AuthSerivice().signOut(),
//             child: Container(
//               // decoration: ,
//               color: Colors.grey[300],
//               width: wt,
//               height: ht * 0.06,
//               child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                       padding: EdgeInsets.fromLTRB(wt * 0.03, 0, 0, 0),
//                       child: const Icon(Icons.logout))),
//             ),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.fromLTRB(wt * 0.01, ht * 0.005, wt * 0.01, 0),
//           child: InkWell(
//             onTap: () async => Navigator.push(
//                 context, CupertinoPageRoute(builder: (context) => DevDash())),
//             child: Container(
//               // decoration: ,
//               color: Colors.grey[300],
//               width: wt,
//               height: ht * 0.06,
//               child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                       padding: EdgeInsets.fromLTRB(wt * 0.03, 0, 0, 0),
//                       child: const Icon(Icons.logo_dev_sharp))),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
