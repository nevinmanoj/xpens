// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xpens/screens/authenticate/components/password.dart';
import 'package:xpens/screens/authenticate/components/textInput.dart';

import '../../services/auth.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

String error = "";
final AuthSerivice _auth = AuthSerivice();
final _formKey = GlobalKey<FormState>();

class signUp extends StatefulWidget {
  final Function toggleView;

  signUp({required this.toggleView});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  String password = "";
  String email = "";
  String name = "";
  void updatePass(String newPass) {
    setState(() {
      password = newPass;
    });
  }

  void updateEmail(String newEmail) {
    setState(() {
      email = newEmail;
    });
  }

  void updateName(String newName) {
    setState(() {
      name = newName;
    });
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    // double wt = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              color: primaryAppColor,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                  height: ht * 0.5,
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
                        // name(),
                        TextInput(
                          onValueChange: updateName,
                          label: "Name",
                        ),
                        SizedBox(
                          height: ht * 0.02,
                        ),
                        // Remail(),
                        TextInput(
                          onValueChange: updateEmail,
                          label: "Email",
                        ),
                        SizedBox(
                          height: ht * 0.02,
                        ),
                        // Rpass(),
                        Password(passChange: updatePass),
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
                                dynamic result = await _auth.registerWithEmail(
                                    email, password, name);
                                if (result == null) {
                                  setState(() {
                                    loading = false;
                                    error = 'Please input valid email';
                                  });
                                }
                              }

                              //sign up auth code
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(70.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        primaryAppColor)),
                            child: Center(
                                child: Text("Sign Up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))),
                          ),
                        ),
                        SizedBox(
                          height: ht * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "Have an account?",
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                widget.toggleView();
                                // Navigator.pop(context);
                              },
                              child: Container(
                                  child: Text("Log In",
                                      style:
                                          TextStyle(color: Colors.blue[400]))),
                            )
                          ],
                        ),
                      ],
                    ),
                  ))),
            ),
            if (loading) Loading(),
          ],
        ));
  }
}
