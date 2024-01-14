import 'package:flutter/material.dart';
import 'package:reciperator/routes/router.dart' as custom_router;
import 'package:reciperator/routes/router_constants.dart';

Widget buildBackground(Widget child) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.green, Colors.black],
        tileMode: TileMode.clamp,
      ),
    ),
    child: child,
  );
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