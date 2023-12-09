import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saleel/addStud.dart';
import 'package:saleel/firebase_options.dart';
import 'package:saleel/homepage.dart';
import 'package:saleel/login.dart';
import 'package:saleel/phoneAut.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
    
     
      home: Login(),
    );
  }
}

