// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saleel/homepage.dart';



class PhoneAut extends StatefulWidget {
  @override
  _PhoneAutState createState() => _PhoneAutState();
}

class _PhoneAutState extends State<PhoneAut> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  Future<void> _addUserToFirestore() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    // Reference to the Firestore collection
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

    // Add user details to Firestore collection
    await usersCollection.add({
      'uid': user!.uid,
      'phoneNumber': user.phoneNumber,
      // Add other user details as needed
    });

    print('User added to Firestore collection');
  } catch (e) {
    print('Error adding user to Firestore: $e');
  }
}

  String? _verificationId;

  // Future<void> _verifyPhoneNumber() async {
  //   try {
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: '+91${_phoneNumberController.text}',
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //         print('Phone number automatically verified and user signed in: ${FirebaseAuth.instance.currentUser!.uid}');
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         print('Phone number verification failed: $e');
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         print('Verification code sent to the provided phone number');
  //         _verificationId = verificationId;
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         _verificationId = verificationId;
  //         print('Auto retrieval timeout');
  //       },
  //     );
  //   } catch (e) {
  //     print('Error verifying phone number: $e');
  //     // Show error in a Snackbar
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error verifying phone number: $e'),
  //         duration: const Duration(seconds: 3),
  //       ),
  //     );
  //   }
  // }
  Future<void> _verifyPhoneNumber() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${_phoneNumberController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          print('Phone number automatically verified and user signed in: ${FirebaseAuth.instance.currentUser!.uid}');

          // Add user details to Firestore collection or perform other actions
          await _addUserToFirestore();

          // Navigate to the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()), // Replace Home() with your home page widget
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Phone number verification failed: $e');

          // Show error in a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error verifying phone number: $e'),
              duration: Duration(seconds: 3),
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          print('Verification code sent to the provided phone number');
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          print('Auto retrieval timeout');
        },
      );
    } catch (e) {
      print('Error verifying phone number: $e');

      // Show error in a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error verifying phone number: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Future<void> _signInWithPhoneNumber() async {
  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: _verificationId!,
  //       smsCode: _smsCodeController.text,
  //     );
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     print('User signed in: ${FirebaseAuth.instance.currentUser!.uid}');
  //   } catch (e) {
  //     print('Error signing in with phone number: $e');
  //   }
  // }
Future<void> _signInWithPhoneNumber() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsCodeController.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      // After successful sign-in, add user details to Firestore collection
      await _addUserToFirestore();

      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()), // Replace HomePage with your home page widget
      );

      print('User signed in: ${FirebaseAuth.instance.currentUser!.uid}');
    } catch (e) {
      print('Error signing in with phone number: $e');
      // Show error in a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red,
          content: Text('Error signing in with phone number: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50,),
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number (+91)',border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _verifyPhoneNumber,
                child: const Text('Verify Phone Number'),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: _smsCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'SMS Code',border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signInWithPhoneNumber,
                child: const Text('Sign In with SMS Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
