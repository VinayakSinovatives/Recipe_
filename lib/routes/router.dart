import 'package:reciperator/ui/authentication/login_homepage.dart';
import 'package:reciperator/ui/authentication/signup_page.dart';
import 'package:reciperator/ui/home/home_page.dart';
import 'package:reciperator/ui/home/my_reviews.dart';
import 'package:reciperator/ui/home/myprofile.dart';
import 'package:reciperator/ui/profile_setup/know_the_user.dart';
import 'package:reciperator/ui/recipes/add_ingredients.dart';
import 'package:reciperator/ui/recipes/recipes.dart';
import 'package:flutter/material.dart';
import 'package:reciperator/routes/router_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings)  {
    switch(settings.name) {
      case landing: 
        return MaterialPageRoute(builder: (_) => const LoginHomePage());
      case signUp: 
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case knowTheUserRoute: 
        return MaterialPageRoute(builder: (_) => const KnowTheUser());
      case homeRoute: 
        return MaterialPageRoute(builder: (_) => const HomePage());
      case profileRoute: 
        return MaterialPageRoute(builder: (_) => const MyProfilePage());
      case reviewRoute: 
        return MaterialPageRoute(builder: (_) => const MyReviews());
      case addIngredientsRoute: 
        return MaterialPageRoute(builder: (_) => const AddIngredients());
      case recipesRoute:
        final List<QueryDocumentSnapshot>? args = settings.arguments as List<QueryDocumentSnapshot>?;
        final List<QueryDocumentSnapshot> results = args ?? [];
        return MaterialPageRoute(builder: (_) => Recipes(results : results));
      default: 
        return MaterialPageRoute( 
          builder: (_) => Scaffold (
            body: Center(child: Text('No route defined for ${settings.name}'))
          ),
        );
    }
  }
}