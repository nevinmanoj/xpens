// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';
import 'authenticate.dart';

String Name = "";
String Remail1 = "";
String Rpassword1 = "";
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
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
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
                        name(),
                        SizedBox(
                          height: ht * 0.02,
                        ),
                        Remail(),
                        SizedBox(
                          height: ht * 0.02,
                        ),
                        Rpass(),
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
                                    Remail1, Rpassword1, Name);
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

class name extends StatefulWidget {
  const name({Key? key}) : super(key: key);

  @override
  State<name> createState() => _nameState();
}

class _nameState extends State<name> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 300,
        decoration: authInputDecoration,
        child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            validator: (value) =>
                value!.isEmpty ? ' Name cannot be empty' : null,
            onChanged: (value) {
              Name = value;
              //Do something with the user input.
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
              hintText: 'Name',
            )));
  }
}

// class loginlink extends StatelessWidget {
//   const loginlink({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: [Container(
//                          child:Text("Have an account?",

//                          ),
//                        ),
//                        SizedBox(width: 5,),
//                        InkWell(
//                         onTap:() {
//                           widget.toggleView();
//                           // Navigator.pop(context);
//                         },
//                          child: Container(
//                            child:Text("Log In",
//                           style:TextStyle(color: Colors.blue[400]))
//                          ),
//                        )],
//                      );
//   }
// }
class Remail extends StatefulWidget {
  const Remail({Key? key}) : super(key: key);

  @override
  State<Remail> createState() => _emailState();
}

class _emailState extends State<Remail> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 300,
        decoration: authInputDecoration,
        child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            validator: (value) =>
                value!.isEmpty ? 'Email cannot be empty' : null,
            onChanged: (value) {
              Remail1 = value;
              //Do something with the user input.
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
              hintText: 'E-Mail',
            )));
  }
}

class Rpass extends StatefulWidget {
  const Rpass({Key? key}) : super(key: key);

  @override
  State<Rpass> createState() => _passState();
}

class _passState extends State<Rpass> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 300,
        decoration: authInputDecoration,
        child: TextFormField(
            obscureText: true,
            textAlign: TextAlign.center,
            validator: (value) =>
                value!.length < 6 ? 'Password too short' : null,
            onChanged: (value) {
              Rpassword1 = value;

              //Do something with the user input.
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
              hintText: 'Password',
            )));
  }
}
