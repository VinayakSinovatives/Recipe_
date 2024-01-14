import 'package:flutter/material.dart';
import 'package:reciperator/app/auth_field.dart';
import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/app/test_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reciperator/routes/router_constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController loginController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordVerifyController;

  @override 
  void initState() {
    loginController = TextEditingController();
    passwordController = TextEditingController();
    passwordVerifyController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    passwordVerifyController.dispose();
    super.dispose();
  }

Future<void> createuser(BuildContext context) async {
  final String username = loginController.text.trim();
  final String psw = passwordController.text.trim();
  final String vpsw = passwordVerifyController.text.trim();

  // Checking if the two passwords are equal
  if (psw != vpsw) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Passwords don't match!"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  // Building the email from the username
  const String aux = "@reciperator.com";
  final String userEmail = '$username$aux';

  try {
    // Creating the user with FirebaseAuth
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userEmail,
      password: psw,
    );

    // Add additional user details to Firestore
    if (userCredential.user != null) {
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'login_id': username,
        'email': userEmail,
      });

      // Navigate to the next screen after successful signup
      Navigator.pushNamed(context, knowTheUserRoute);
    }
  } on FirebaseAuthException catch (e) {
    String errorMessage = 'An error occurred during sign up.';
    if (e.code == 'weak-password') {
      errorMessage = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      errorMessage = 'An account already exists for that username.';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } catch (e) {
    debugPrint("An error occurred in the Signup page: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to sign up."),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: buildBackground(
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: null,
          body: FutureBuilder(
            future: null,
            builder: (context, snapshot) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 0.2 * h),
                    const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 0.02 * h),
                    CustomTextField(text: 'Username', width: w, mycontroller: loginController, v: false),
                    SizedBox(height: 0.02 * h),
                    CustomTextField(text: 'Password', width: w, mycontroller: passwordController, v: true),
                    SizedBox(height: 0.02 * h),
                    CustomTextField(text: 'Re-type Password', width: w, mycontroller: passwordVerifyController, v: true),
                    SizedBox(height: 0.02 * h),
                    Button(
                      type: ButtonType.contin, // Enum value for button type
                      label: 'Create Account',
                      onPressed: () async { createuser(context); }
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
