import 'package:flutter/material.dart';

import '../../../shared/constants.dart';

bool flag = false;

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;
  const SettingsItem(
      {super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // flag = !flag;
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          // color: flag ? secondaryAppColor : primaryAppColor,
          borderRadius: BorderRadius.circular(20)),
      height: ht * 0.16,
      width: wt * 0.26,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: ht * 0.02,
            ),
            Icon(
              icon,
              color: primaryAppColor,
              // color: !flag ? secondaryAppColor : primaryAppColor,
              size: 30,
            ),
            SizedBox(
              height: ht * 0.02,
            ),
            Container(
              alignment: Alignment.center,
              // color: Colors.green,
              width: wt * 0.26,
              child: Text(
                textAlign: TextAlign.center,
                title,

                style: const TextStyle(
                  fontSize: 17,
                  // color: !flag ? secondaryAppColor : primaryAppColor,
                ),
                // overflow: TextOverflow.visible,
              ),
            )
          ],
        ),
      ),
    );
  }
}
