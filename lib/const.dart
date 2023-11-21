import 'package:flutter/material.dart';
import 'package:cafito/views/login.dart';

class Constants {
  
  static void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }
}
