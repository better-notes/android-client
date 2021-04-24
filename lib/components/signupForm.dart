import 'package:flutter/material.dart';
import 'package:flutter_application_1/accounts/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpCard extends StatelessWidget {
  SignUpCard({
    required this.enterStateSetter,
    required this.loginController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.storage,
    required this.setAppStateHome,
  });

  final TextEditingController loginController;
  final VoidCallback enterStateSetter;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FlutterSecureStorage storage;
  final VoidCallback setAppStateHome;

  final _signUpFormKey = GlobalKey<FormState>();

  void writeUser(String token) async {
    await storage.write(key: 'authToken', value: token);
    setAppStateHome();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 300,
      decoration: BoxDecoration(
        color: Color(0xFF17212B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Center(
            child: Padding(
              child: Text(
                'Sign up',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              padding: EdgeInsets.all(10),
            ),
          ),
          Center(
            child: Form(
                key: _signUpFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: loginController,
                      decoration: InputDecoration(
                          hintText: 'Login',
                          border: OutlineInputBorder(),
                          fillColor: Color(0xFF242F3D)),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: passwordController,
                      decoration: InputDecoration(
                          hintText: 'Password', border: OutlineInputBorder()),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter some text';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                          hintText: 'Password', border: OutlineInputBorder()),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_signUpFormKey.currentState!.validate()) {
                                  register(
                                          loginController.text,
                                          passwordController.text,
                                          confirmPasswordController.text)
                                      .then((data) => {writeUser(data)})
                                      .catchError((error) => {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(error.toString()),
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
                                            )
                                          });
                                }
                              },
                              child: const Text('Sign up'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                loginController.text = '';
                                passwordController.text = '';
                                confirmPasswordController.text = '';
                                enterStateSetter();
                              },
                              child: const Text('Log in'),
                            ),
                          ],
                        )),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
