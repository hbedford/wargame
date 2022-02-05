import 'package:flutter/material.dart';
import 'package:wargame/src/views/login/login_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginView());
  }
}
