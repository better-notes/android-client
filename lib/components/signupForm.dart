import 'package:flutter/material.dart';
import 'package:flutter_application_1/accounts/services.dart';
import 'package:flutter_application_1/theming.dart';

enum buttonStates { processing, waitingForClick }

class SignUpCard extends StatefulWidget {
  SignUpCard({
    required this.enterStateSetter,
    required this.loginController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.setValue,
    required this.setAppStateHome,
  });

  final TextEditingController loginController;
  final VoidCallback enterStateSetter;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Function(String, String) setValue;
  final VoidCallback setAppStateHome;
  @override
  _SignUpCardState createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  final _signUpFormKey = GlobalKey<FormState>();
  var signUpButtonState = buttonStates.waitingForClick;
  void writeUser(String token) async {
    await widget.setValue('authToken', token);
    widget.setAppStateHome();
  }

  Widget getSignUpButtonChild() {
    switch (signUpButtonState) {
      case buttonStates.waitingForClick:
        return Text('Sign up');
      case buttonStates.processing:
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator.adaptive(),
        );
      default:
        return Text('Log in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xFF0E1621),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Center(
                child: Padding(
                  child: Text(
                    'Sing up',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  padding: EdgeInsets.all(10),
                ),
              ),
              Center(
                child: Form(
                    key: _signUpFormKey,
                    child: AutofillGroup(
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: TextFormField(
                                  autofillHints: <String>[
                                    AutofillHints.username,
                                  ],
                                  style: TextStyle(color: Colors.white),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  controller: widget.loginController,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      icon: Icon(Icons.person),
                                      hintText: 'Login',
                                      filled: true,
                                      fillColor: inputColor),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 80,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: TextFormField(
                                  autofillHints: <String>[
                                    AutofillHints.password
                                  ],
                                  style: TextStyle(color: Colors.white),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  controller: widget.passwordController,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      icon: Icon(Icons.lock),
                                      hintText: 'Password',
                                      filled: true,
                                      fillColor: inputColor),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 80,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: TextFormField(
                                  autofillHints: <String>[
                                    AutofillHints.password
                                  ],
                                  style: TextStyle(color: Colors.white),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    if (value !=
                                        widget.passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                  controller: widget.confirmPasswordController,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      icon: Icon(Icons.lock),
                                      hintText: 'Confirm password',
                                      filled: true,
                                      fillColor: inputColor),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 30, bottom: 10, right: 30),
                              child: Center(
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                    onPressed: (signUpButtonState ==
                                            buttonStates.processing)
                                        ? null
                                        : () {
                                            if (_signUpFormKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                signUpButtonState =
                                                    buttonStates.processing;
                                              });
                                              register(
                                                      widget
                                                          .loginController.text,
                                                      widget.passwordController
                                                          .text,
                                                      widget
                                                          .confirmPasswordController
                                                          .text)
                                                  .then((data) =>
                                                      {writeUser(data)})
                                                  .catchError((error) {
                                                setState(() {
                                                  signUpButtonState =
                                                      buttonStates
                                                          .waitingForClick;
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content:
                                                        Text(error.toString()),
                                                    duration: Duration(
                                                        milliseconds: 1500),
                                                    width:
                                                        280.0, // Width of the SnackBar.
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            8.0), // Inner padding for SnackBar content.
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                );
                                              });
                                            }
                                          },
                                    child: getSignUpButtonChild()),
                              ),
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Center(
                                    child: Text(
                                      "Already have an account?",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        widget.loginController.text = '';
                                        widget.passwordController.text = '';
                                        widget.confirmPasswordController.text =
                                            '';
                                        widget.enterStateSetter();
                                      },
                                      child: Text(
                                        "Log in",
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}
