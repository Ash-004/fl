import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psychetrack/login.dart';
import 'package:psychetrack/signup.dart';
import 'package:psychetrack/home.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? Mylogin(onClickedSignUp: toggle)
      : MySignup(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
