import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/SignUpPage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/accounts/services.dart';

enum buttonStates { processing, waitingForClick }

class EnterPage extends StatefulWidget {
  EnterPage({
    required this.setAppStateHome,
    required this.setValue,
  });
  final VoidCallback setAppStateHome;
  final Function(String, String) setValue;
  @override
  _EnterPageState createState() => _EnterPageState();
}

class _EnterPageState extends State<EnterPage> {
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

  final loginLoginController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final signUpLoginController = TextEditingController();
  final signUpPassword1Controller = TextEditingController();
  final signUpPassword2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: SvgPicture.asset(
              'assets/icon.svg',
              height: 30,
              width: 30,
              color: Theme.of(context).buttonColor,
            ),
          ),
        ),
        body: Container(
          child: Container(
            child: Center(
                child: Container(
                    decoration: BoxDecoration(
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
                                    fontWeight: FontWeight.bold, fontSize: 20),
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
                                            padding: EdgeInsets.only(
                                                left: 30, right: 30),
                                            child: TextFormField(
                                              autofillHints: <String>[
                                                AutofillHints.username,
                                              ],
                                              validator: (value) {
                                                if (value!.trim().isEmpty) {
                                                  return 'Please enter some text';
                                                }
                                                return null;
                                              },
                                              controller:
                                                  this.loginLoginController,
                                              decoration: InputDecoration(
                                                border: UnderlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                icon: Icon(
                                                  Icons.alternate_email,
                                                ),
                                                hintText: 'Login',
                                                filled: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 80,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 30, right: 30),
                                            child: TextFormField(
                                              autofillHints: <String>[
                                                AutofillHints.password
                                              ],
                                              obscureText: true,
                                              validator: (value) {
                                                if (value!.trim().isEmpty) {
                                                  return 'Please enter some text';
                                                }
                                                return null;
                                              },
                                              controller:
                                                  this.loginPasswordController,
                                              decoration: InputDecoration(
                                                border: UnderlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                icon: Icon(
                                                  Icons.lock,
                                                ),
                                                hintText: 'Password',
                                                filled: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              left: 30,
                                              bottom: 10,
                                              right: 30),
                                          child: Center(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ))),
                                              onPressed: (loginButtonState ==
                                                      buttonStates.processing)
                                                  ? null
                                                  : () {
                                                      if (_loginFormKey
                                                          .currentState!
                                                          .validate()) {
                                                        HapticFeedback
                                                            .vibrate();

                                                        setState(() {
                                                          loginButtonState =
                                                              buttonStates
                                                                  .processing;
                                                        });
                                                        authenticate(
                                                          this
                                                              .loginLoginController
                                                              .text,
                                                          this
                                                              .loginPasswordController
                                                              .text,
                                                        )
                                                            .then((data) => {
                                                                  writeUser(
                                                                      data)
                                                                })
                                                            .catchError(
                                                                (error) {
                                                          setState(() {
                                                            loginButtonState =
                                                                buttonStates
                                                                    .waitingForClick;
                                                          });
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(error
                                                                  .toString()),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      1500),
                                                              width: 280.0,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Center(
                                                child: Text(
                                                  "Don't have an account?",
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Center(
                                                child: TextButton(
                                                  onPressed: () {
                                                    HapticFeedback.vibrate();
                                                    this
                                                        .loginLoginController
                                                        .clear();
                                                    this
                                                        .loginPasswordController
                                                        .clear();
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SignUpPage(
                                                                loginController:
                                                                    signUpLoginController,
                                                                passwordController:
                                                                    signUpPassword1Controller,
                                                                confirmPasswordController:
                                                                    signUpPassword2Controller,
                                                                setValue: widget
                                                                    .setValue,
                                                                setAppStateHome:
                                                                    widget
                                                                        .setAppStateHome,
                                                                writeUser: this
                                                                    .writeUser,
                                                              )),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Sign up",
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
                    ))),
          ),
        ));
  }
}
