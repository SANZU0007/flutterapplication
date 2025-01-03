import 'package:flutter/material.dart';
import 'package:testapp/constants.dart';

import 'login_screen.dart';

void main() {
  runApp(initialScreen());
}

class initialScreen extends StatelessWidget {
  const initialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      title: appName,
      debugShowCheckedModeBanner: false,
    );
  }
}
