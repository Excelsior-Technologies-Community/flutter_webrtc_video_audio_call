import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final myUserId = "user_${Random().nextInt(9999)}";

  runApp(MyApp(myUserId: myUserId));
}

class MyApp extends StatelessWidget {
  final String myUserId;

  const MyApp({super.key, required this.myUserId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WebRTC Audio Video Call',
      home:HomeScreen(myUserId: myUserId)
    );
  }
}
