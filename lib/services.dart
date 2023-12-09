import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saleel/homepage.dart';
import 'package:saleel/login.dart';
import 'package:saleel/models/student_model.dart';
import 'package:saleel/models/user_model.dart';

class FirebaseServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Studmodel? _studmodel;
  Studmodel get studmodel => _studmodel!;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  Future<void> saveUser(
    String registerid,
    String userName,
    String userEmail,
    String userNumber,
  ) async {
    _userModel = UserModel(
      id: registerid,
      name: userName,
      email: userEmail,
    );

//Save user data
    await firebaseFirestore
        .collection('users')
        .doc(registerid)
        .set(_userModel!.toMap());
  }

  Future<void> signUpUser(String userName, String userEmail, String userNumber,
      userPassword, context) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);

      final user = firebaseAuth.currentUser;
      user?.sendEmailVerification();
      await saveUser(
        userCredential.user!.uid,
        userName,
        userEmail,
        userNumber,
      );
      myCustomAlert(
        context,
        '',
        userEmail,
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Pasword is too weak')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Email already used')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  myCustomAlert(context, message, email, Function onTap) {
    CoolAlert.show(
        onConfirmBtnTap: () {
          onTap;
        },
        backgroundColor: Colors.green,
        title: 'Verification',
        text: 'A verification link sent to $email. Verify email before login.',
        confirmBtnColor: Colors.indigo,
        context: context,
        type: CoolAlertType.info,
        widget: Container(
          alignment: Alignment.center,
          child: Column(
            children: [Text(message)],
          ),
        ),
        width: 300);
  }

  Future<void> userLogin(String userEmail, String userPassword, context) async {
  try {
    if (userEmail.isEmpty || userPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password cannot be empty')),
      );
      return;
    }

    await firebaseAuth.signInWithEmailAndPassword(
      email: userEmail,
      password: userPassword,
    );

    final user = firebaseAuth.currentUser;
    final emailVerified = user!.emailVerified;
    print('Verification : $emailVerified');

    if (!emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please verify your email')),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
        (route) => false,
      );
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user found')),
      );
    } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user found')),
      );
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect password')),
      );
    }
  } catch (e) {
    print(e);
   
  }
}
}
