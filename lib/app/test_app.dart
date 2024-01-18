import 'package:flutter/material.dart';
import 'package:reciperator/routes/router.dart' as custom_router;
import 'package:reciperator/routes/router_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget buildBackground(Widget child) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF3CEE39), Color(0xFF000000)],
        tileMode: TileMode.clamp,
      ),
    ),
    child: child,
  );
}


Future<void> reviewfun(String image, double review, String title, String uid, String link) async {
  //Opening the reviews table
  CollectionReference reviews = FirebaseFirestore.instance.collection('recipes');

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection('recipes')
    .where('user_id', isEqualTo: uid)
    .where('link', isEqualTo: link)
    .get();
  
  //If it is in this user
  if (querySnapshot.docs.isNotEmpty) {
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      FirebaseFirestore.instance.collection('recipes').doc(document.id).update({
        'review': review
      });
      break;
    }
  }
  else{
    //Appending a recommendation
    await reviews.doc().set({
      'review': review,
      'title': title,
      'image': image,
      'user_id': uid,
      'link': link,
    });
  }
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus(); // Clear focus from any focused widget
  FocusScope.of(context).requestFocus(FocusNode()); // Request focus on an empty FocusNode
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Giving name
      title: 'Flutter Demo',
      //Making the background transparent and giving access to the flutter material
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      onGenerateRoute: custom_router.Router.generateRoute,
      initialRoute: landing,
    );
  }
}

