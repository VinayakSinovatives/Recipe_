import 'package:reciperator/app/test_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
    )
  );
  WidgetsFlutterBinding.ensureInitialized();
  firebaseinitialization();
  runApp(const MyApp());
}

Future<void> firebaseinitialization() async{
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDjyww9nfeBHtHImZ1MGLS3pJ5N5UaclxI',
      appId: '1:1019351826894:android:678fc7a30532f4b9246b9f',
      messagingSenderId: '1019351826894',
      projectId: 'reciperator-app-main',
      storageBucket: 'reciperator-app-main.appspot.com',
    ),
  );
}



