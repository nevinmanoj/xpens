// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';

import 'ThemeData.dart';
import 'screens/wrapper.dart';
import 'services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(StreamProvider<User?>.value(
    value: AuthSerivice().user,
    initialData: null,
    builder: (context, child) {
      var user = Provider.of<User?>(context);
      return ChangeNotifierProxyProvider<User?, UserInfoProvider>(
        create: (_) => UserInfoProvider(user: user),
        update: (context, user, userInfoProvider) {
          if (userInfoProvider == null) return UserInfoProvider(user: user);
          if (user != null) userInfoProvider.setUser(user);
          // userInfoProvider.user = user;
          return userInfoProvider;
        },
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themedata,
            home: wrapper(),
          );
        },
      );
    },
  ));
}
