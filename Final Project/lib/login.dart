// ignore_for_file: unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController userTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  // ignore: unused_element
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  // Function to handle sign in
  // ignore: unused_element
  static Future<User?> _signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Handle successful sign in here
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        // print("No User found for that email");
      } else if (e.code == "wrong-password") {
        //print("Wrong password provided for that user");
      } else if (e.code == "invalid-email") {
        //print("Invalid email address");
      } else {
        //print(e.code);
      }
      // Handle sign in error here
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    String email = '';
    String pass = '';

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                "Welcome",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    left: 35,
                    right: 35),
                child: Column(children: [
                  TextField(
                    controller: userTextController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey,
                      filled: true,
                      hintText: "email id",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    obscureText: true,
                    controller: passwordTextController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey,
                      filled: true,
                      hintText: "password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                                email: userTextController.text,
                                password: passwordTextController.text);
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, 'home');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          SnackBar snackBar = const SnackBar(
                            content: Text('No User found for that email.'),
                          );
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (e.code == 'wrong-password') {
                          SnackBar snackBar = const SnackBar(
                            content:
                                Text('Wrong Password provided for that user.'),
                          );
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          debugPrint('Error: $e');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    child: const Text('SIGN IN'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'register');
                        },
                        child: const Text('SIGN UP',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Color(0xff4c505b))),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('FORGOT PASSWORD?',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Color(0xff4c505b))),
                      )
                    ],
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
