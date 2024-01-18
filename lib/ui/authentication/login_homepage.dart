import 'package:flutter/material.dart';
import 'package:reciperator/app/auth_field.dart';
import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/app/test_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reciperator/routes/router_constants.dart';
import 'package:reciperator/app/colors.dart';

class LoginHomePage extends StatefulWidget {
  const LoginHomePage({super.key});

  @override
  State<LoginHomePage> createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage> {
  //Controllers to handle the text input from the user
  late final TextEditingController loginController;
  late final TextEditingController passwordController;

  //initialize the controllers
  @override 
  void initState() {
    loginController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  // Clean up the controller when the widget is disposed.
  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //check if this user exists
  Future<void> checkuser() async{
    final username = loginController.text;
    final psw = passwordController.text;

    const aux = "@reciperator.com";
    String usremail = '$username$aux';
    try {
      showDialog(
        context: context,
        builder:(context) => const Center(child: CircularProgressIndicator())  
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usremail,
        password: psw,
      );

      Navigator.pop(context);
      //If everything is ok, then we navigate to the home screen
      Navigator.pushNamed(context, homeRoute);
    } 
    on FirebaseAuthException catch (e) {

      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      showDialog(
        context: context, 
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Invalid Credentials", style:TextStyle(color: Colors.white)), 
            content: const Text("The username or the password you provided was incorrect", style:TextStyle(color: Colors.white)),
            backgroundColor: AppColors.promptBackground,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('Got It!'))
            ]
          );
        }
      );
      
    }
    catch (e) {
      debugPrint("An error occured in the Signup page: $e");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    //Percentage stuff, to cover a percentage of the screen 
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return GestureDetector(
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
                        "Welcome!" ,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                        )
                      ),
                      //-----------"Login to find the best recipes!" text-----------
                      Container(
                        width: MediaQuery.of(context).size.width-150,
                        child: const Text(
                          "Login to find the best recipes!",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          )
                        ),
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
                      //-----------Login Button-----------
                      Button (type: ButtonType.contin, label:'Login', onPressed: () async {
                        checkuser();
                      }),
                      //-----------Some space-----------
                      SizedBox(height: 0.02*h),
                      //-----------"Login to find the best recipes!" text-----------
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        )
                      ),
                      //-----------Some space-----------
                      SizedBox(height: 0.02*h),
                      //-----------SignUp Button-----------
                      Button (type: ButtonType.contin, label:'Sign Up', onPressed: () {Navigator.pushNamed(context, signUp);}),
                      //-----------Some space-----------
                      SizedBox(height: 0.04*h),
                      //-----------Adding the image-----------
                      Image.asset(
                        'assets/image1.jpg', 
                        height: 0.2*h, 
                        width: 0.2*w, 
                      ),
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
