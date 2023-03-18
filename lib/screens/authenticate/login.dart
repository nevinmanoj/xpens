// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/services/toast.dart';

import '../../services/auth.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

String password1 = "";
String email1 = "";

class login extends StatefulWidget {
  final Function toggleView;
  login({required this.toggleView});

  @override
  State<login> createState() => _loginState();
}

final AuthSerivice _auth = AuthSerivice();

class _loginState extends State<login> {
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: primaryAppColor),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
                height: ht * 0.45,
                width: 350,
                //color: Colors.green,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 213, 213, 213),
                ),
                child: Center(
                    child: Form(
                  key: _formKey,
                  child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      SizedBox(
                        height: ht * 0.055,
                      ),
                      Text(error,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: ht * 0.02,
                      ),
                      Lemail(),
                      SizedBox(
                        height: ht * 0.02,
                      ),
                      Lpass(),
                      SizedBox(
                        height: ht * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text("Dont have an account?"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              widget.toggleView();

                              //  Navigator.push(context,MaterialPageRoute(builder: (context) =>signUp()),);
                            },
                            child: Container(
                                child: Text("Sign-up",
                                    style: TextStyle(color: Colors.blue[400]))),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ht * 0.02,
                      ),
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.loginWithEmail(email1, password1);

                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error =
                                      'Could not Login with the given credentials ';
                                });
                              }
                            }

                            // Navigator.push(context,MaterialPageRoute(builder: (context) =>  home()));
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(70.0),
                              )),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryAppColor)),
                          child: Center(
                              child: Text("Log In",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text("Forgot your password?"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              if (email1 != "") {
                                AuthSerivice().Passwordreset(email1, context);
                              } else {
                                showToast(context: context, msg: "Enter email");
                              }
                            },
                            child: Container(
                                child: Text("Send reset link",
                                    style: TextStyle(color: Colors.blue[400]))),
                          )
                        ],
                      ),
                    ],
                  ),
                ))),
          ),
          if (loading) Loading(),
        ],
      ),
    );
  }
}

class Lemail extends StatefulWidget {
  const Lemail({Key? key}) : super(key: key);

  @override
  State<Lemail> createState() => _emailState();
}

class _emailState extends State<Lemail> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 300,
        decoration: authInputDecoration,
        child: TextFormField(
            validator: (value) =>
                value!.isEmpty ? ' Email cannot be empty' : null,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            onChanged: (value) {
              email1 = value;
              //Do something with the user input.
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
              hintText: 'E-Mail',
            )));
  }
}

class Lpass extends StatefulWidget {
  const Lpass({Key? key}) : super(key: key);

  @override
  State<Lpass> createState() => _passState();
}

class _passState extends State<Lpass> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 300,
        decoration: authInputDecoration,
        child: TextFormField(
            validator: (value) => value!.isEmpty ? 'Enter password' : null,
            obscureText: true,
            textAlign: TextAlign.center,
            onChanged: (value) {
              password1 = value;

              //Do something with the user input.
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
              hintText: 'Password',
            )));
  }
}
