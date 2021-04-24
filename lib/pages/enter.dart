import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/components/loginForm.dart';
import 'package:flutter_application_1/components/signupForm.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/theming.dart' as theming;

enum enterState { login, signup }

class EnterPage extends StatefulWidget {
  EnterPage({
    required this.setAppStateHome,
    required this.storage,
  });
  final VoidCallback setAppStateHome;
  final FlutterSecureStorage storage;
  @override
  _EnterPageState createState() => _EnterPageState();
}

class _EnterPageState extends State<EnterPage> {
  var _state = enterState.login;

  final Widget appLogo = SvgPicture.asset(
    'assets/grid-dynamic.svg',
    height: 30,
  );
  void _setSignUpState() {
    setState(() {
      _state = enterState.signup;
    });
  }

  void _setLogInState() {
    setState(() {
      _state = enterState.login;
    });
  }

  Widget conditionalCard() {
    switch (_state) {
      case enterState.login:
        return LoginCard(
          enterStateSetter: _setSignUpState,
          loginController: loginLoginController,
          passwordController: loginPasswordController,
          storage: widget.storage,
          setAppStateHome: widget.setAppStateHome,
        );
      case enterState.signup:
        return SignUpCard(
          enterStateSetter: _setLogInState,
          loginController: signUpLoginController,
          passwordController: signUpPassword1Controller,
          confirmPasswordController: signUpPassword2Controller,
          storage: widget.storage,
          setAppStateHome: widget.setAppStateHome,
        );
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
          title: Center(child: appLogo),
          backgroundColor: theming.headerColor,
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(color: Color(0xFF0E1621)),
          child: Container(
            child: Center(child: conditionalCard()),
          ),
        ));
  }
}
