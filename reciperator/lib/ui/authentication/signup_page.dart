import 'package:flutter/material.dart';
import 'package:reciperator/app/auth_field.dart';
import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/app/test_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reciperator/routes/router_constants.dart';

//The basic Signup Page
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //Controllers to handle the text input from the user
  late final TextEditingController loginController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordVerifyController;

  //initialize the controllers
  @override 
  void initState() {
    loginController = TextEditingController();
    passwordController = TextEditingController();
    passwordVerifyController = TextEditingController();
    super.initState();
  }

  // Clean up the controllers when the widget is disposed.
  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    passwordVerifyController.dispose();
    super.dispose();
  }

  //Checking if there exists a user with this name, then checking if password is strong enough
  //then if both passwords are the same. Shall all the controls passed, then the user is created
  //and driven to the screen to choose food types 
  Future<void> createuser(BuildContext context) async {
    //Taking the values of the user 
    final username = loginController.text;
    final psw = passwordController.text;
    final vpsw = passwordVerifyController.text;

    //Checking if the 2 passwords are equal
    if(psw != vpsw){

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text("Passwords don't match!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          )
        );

      return;
    }

    //Now we proceed to build the user for the authentication, after the right checks
    const aux = "@reciperator.com";
    String usremail = '$username$aux';
    UserCredential? userCredential = null;
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: usremail,
        password: psw
      );

    } 
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text('The password provided is too weak.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          )
        );

      } 
      else if (e.code == 'email-already-in-use') {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text('The account already exists for that name.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          )
        );

      }
    } 
    catch (e) {
      debugPrint("An error occured in the Signup page: $e");
      return;
    }

    //And now creating the entity
    //Instance to the collection (pretty much the matrix 'users')
    if (userCredential != null && userCredential.user != null) {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      //Extracting data to make a thorough profile in the database
      String uid = userCredential.user!.uid;
      await users.doc(uid).set({
        'login_id': username,
        'password': psw,
        'email': "",
        'country': "",
        'phone': "",
        'image': "",
      });

      //If everything is ok, we navigate to the home screen
      Navigator.pushNamed(context, knowTheUserRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Percentage stuff, to cover a percentage of the screen 
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return 
      GestureDetector(
      onTap: () {
        hideKeyboard(context); // Hide keyboard when tapping outside of widgets
      },
      child: buildBackground(
          Scaffold(
            resizeToAvoidBottomInset: false,
            //The top bar part of the code
            appBar: null,
            //The top bar part of the code
            //The main body of the code
            //First, i want everything to be in the center
            body: FutureBuilder(
              future: null,
              builder: (context, snapshot) {
                return Center( 
                  child: 
                    //Everything will be within this main column, so all components will be children of this
                    Column(
                      children:[
                        //-----------Leave some space from the upper part-----------
                        SizedBox(height: 0.2*h),
                        //-----------"Welcome" text-----------
                        const Text(
                          "Sign Up" ,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          )
                        ),
                        //-----------Some space-----------
                        SizedBox(height: 0.02*h),
                        //-----------Login username Textfield-----------
                        CustomTextField(text: 'Username', width: w, mycontroller: loginController, v: false),
                        //-----------Some space-----------
                        SizedBox(height: 0.02*h),
                        //-----------Password username Textfield-----------
                        CustomTextField(text: 'Password', width: w, mycontroller: passwordController, v: true),
                        //-----------Some space-----------
                        SizedBox(height: 0.02*h),
                        //-----------Password username Textfield-----------
                        CustomTextField(text: 'Verify Password', width: w, mycontroller: passwordVerifyController, v: true),
                        //-----------Some space-----------
                        SizedBox(height: 0.02*h),
                        //-----------Create Account Button-----------
                        Button (type: 'Miltos', label:'Create Account', onPressed: () async {createuser(context);}),
                      ]
                    )
                );
              }
            )
        )
      )
    );
  }
}