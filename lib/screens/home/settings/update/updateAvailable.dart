import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xpens/shared/utils/toast.dart';

import '../../../../services/providers/UserInfoProvider.dart';

class updateAvailable extends StatelessWidget {
  const updateAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    void openURL() async {
      try {
        Uri uri = Uri.parse("https://nevinmanoj.github.io/xpens/");

        await launchUrl(uri);
      } catch (e) {
        showToast(context: context, msg: e.toString());
      }
    }

    var userInfo = Provider.of<UserInfoProvider>(context);
    String newversion = '';
    String nvData = "";
    try {
      newversion = userInfo.latestVersionData["currentVersion"];
      nvData = userInfo.latestVersionData["bio"];
    } catch (e) {
      print("erorr fetching version data");
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 10),
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/release.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    child: const Text(
                      'Xpens',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 59, 59, 59)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      'V$newversion',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              )
            ],
          ),

          //whats new
          const Divider(
            thickness: 1,
            color: Color.fromARGB(255, 216, 216, 216),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 10),
            child: Text(
              "Whats new in $newversion",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text(
              nvData,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Center(
                child: TextButton(
                    onPressed: openURL, child: Text("Download $newversion"))),
          )
        ],
      ),
    );
  }
}
