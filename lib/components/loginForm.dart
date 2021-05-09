import 'package:flutter/material.dart';
import 'package:flutter_application_1/accounts/services.dart';
import 'package:flutter_application_1/theming.dart';

enum buttonStates { processing, waitingForClick }

class LoginCard extends StatefulWidget {
  LoginCard({
    required this.enterStateSetter,
    required this.loginController,
    required this.passwordController,
    required this.setValue,
    required this.setAppStateHome,
  });

  final TextEditingController loginController;
  final VoidCallback enterStateSetter;
  final TextEditingController passwordController;
  final Function(String, String) setValue;
  final VoidCallback setAppStateHome;

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _loginFormKey = GlobalKey<FormState>();
  var loginButtonState = buttonStates.waitingForClick;

  void writeUser(String token) async {
    await widget.setValue('authToken', token);
    widget.setAppStateHome();
  }

  Widget getLoginButtonChild() {
    switch (loginButtonState) {
      case buttonStates.waitingForClick:
        return Text('Log in');
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
                    'Log in',
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
                    key: _loginFormKey,
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
                                  onPressed: (loginButtonState ==
                                          buttonStates.processing)
                                      ? null
                                      : () {
                                          if (_loginFormKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              loginButtonState =
                                                  buttonStates.processing;
                                            });
                                            authenticate(
                                              widget.loginController.text,
                                              widget.passwordController.text,
                                            )
                                                .then(
                                                    (data) => {writeUser(data)})
                                                .catchError((error) {
                                              setState(() {
                                                loginButtonState = buttonStates
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
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              );
                                            });
                                          }
                                        },
                                  child: getLoginButtonChild(),
                                ),
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
                                      "Don't have an account?",
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
                                        widget.enterStateSetter();
                                      },
                                      child: Text(
                                        "Sign up",
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
