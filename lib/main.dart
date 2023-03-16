import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/shared/constants.dart';

import 'screens/wrapper.dart';
import 'services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(StreamProvider<User?>.value(
    value: AuthSerivice().user,
    initialData: null,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: wrapper(),
    ),
  ));
}
