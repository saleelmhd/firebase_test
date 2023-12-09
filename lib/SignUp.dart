// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:saleel/homepage.dart';
import 'package:saleel/login.dart';
import 'package:saleel/phoneAut.dart';
import 'package:saleel/services.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});
  @override
  State<SignUP> createState() => _SignUPState();
}

bool _isPasswordVisible = false;

class _SignUPState extends State<SignUP> {
  TextEditingController mail = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  final firebaseServices = FirebaseServices();

  final formkey = GlobalKey<FormState>();
  bool passFieldEmpty = true;
  void _updatepassEmpty() {
    setState(() {
      passFieldEmpty = _passController.text.isEmpty;
    });
  }
 Future<void> disconnectGoogleAccount() async {
  try {
    await GoogleSignIn().signOut();
    // Additional steps may be needed based on your application logic
    print('Google account disconnected successfully');
  } catch (e) {
    print('Error disconnecting Google account: $e');
    // Handle error, show a Snackbar, or perform other actions
     // Handle error, show a Snackbar, or perform other actions

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error disconnecting Google account: $e'),
          duration: Duration(seconds: 3),
        ),
      );
  }
}
Future<dynamic> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled the sign-in process

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;

      // Add user details to Firestore collection
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'displayName': user.displayName,
          'email': user.email,
          // Add other user details as needed
        });

        // Navigate to the home page after successful sign-in
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => Home())));
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passController.addListener(_updatepassEmpty);
  }

  @override
  void dispose() {
    // Clean up the controllers and remove the listeners

    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 249, 249),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 50,
            ),
            const Center(
              child: Column(
                children: [
                  Text("Hello!",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.indigo)),
                  Text("Welcome back",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.indigo)),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ), Card(
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Name',
                                    hintStyle: const TextStyle(color: Colors.grey),

                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ), const SizedBox(
              height: 10,
            ),
            Card(
              child: TextFormField(
                controller: mail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                                    hintStyle: const TextStyle(color: Colors.grey),

                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(
              height: 10,
            ),Card(
              child: TextFormField(
                  controller: numberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Phone Number',
                                      hintStyle: const TextStyle(color: Colors.grey),
              
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
            ), const SizedBox(
              height: 10,
            ),
            Card(
              child: TextFormField(
                controller: _passController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: passFieldEmpty
                      ? null
                      : IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
           
            const SizedBox(
              height: 25,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                   firebaseServices.signUpUser(nameController.text, mail.text, numberController.text, _passController.text, context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width / 1.4, 50),
                  backgroundColor:Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: const Text(
                  "Sign Up",
                  style: (TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const Login())));

                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            const SizedBox(
              height: 17,
            ),
            const Divider(
              color: Colors.grey,
              indent: 22,
              endIndent: 22,
            ),
            const SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
  onTap: () async {
   
      // Disconnect the current Google Sign-In account
    await disconnectGoogleAccount();

    // Sign in with Google
     User? user = await signInWithGoogle(context);
    
    if (user != null) {
      // User signed in successfully
      print('User signed in: ${user.displayName}');
    } else {
      // Sign-in failed
      print('Sign-in with Google failed.');
    }
  },
  child: Container(
    width: 105,
    height: 70,
    child: Image.asset('images/google.png'),
  ),
),
                InkWell(onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: ((context) => PhoneAut())));
                },
                  child: Container(
                    width: 105,
                    height: 35,
                    child: Image.asset('images/phone.png'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ]),
        ),
      ),
    );
  }
}
