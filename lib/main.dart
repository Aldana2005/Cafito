import 'package:flutter/material.dart';
import 'package:cafito/views/admin/inventory.dart';
import 'package:cafito/views/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cafito/views/users/products.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cafito',
      theme: ThemeData(
      ),
      home: const Login(),
    );
  }
}

