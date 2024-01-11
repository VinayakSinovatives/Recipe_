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
      apiKey: 'AIzaSyBN99ylGb5P1FJtXojLJ_lRmHleq-1UTm4',
      appId: '1:319053524390:android:19e0acb6e205b4b6c43367',
      messagingSenderId: '319053524390',
      projectId: 'ntua-gui-apptest',
    ),
  );
}


