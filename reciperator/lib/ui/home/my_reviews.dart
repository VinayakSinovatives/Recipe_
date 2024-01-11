import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/ui/home/menu.dart';
import 'package:reciperator/app/recipe_card.dart';

class MyReviews extends StatefulWidget {
  const MyReviews({super.key});

  @override
  State<MyReviews> createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "My Reviews", 
          style: TextStyle(fontSize: 30)
        ),
        backgroundColor: AppColors.green,
      ), 
      //backgroundColor: Colors.transparent,
      drawer: const Menu(), 
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient( 
                begin: Alignment.topCenter, 
                end: Alignment.bottomCenter,
                colors: AppColors.background,
              )
            )
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:26, top: 138),
                  child: Column(
                    children: [ 
                      RecipeCard(title: 'Spanish Tortillas', review: 4.0, image: 'https://picsum.photos/200/300', isReview: true, overlay: () {}),
                      RecipeCard(title: 'Chocolate Pancakes', review:3.4, image: 'https://picsum.photos/200/300', isReview: true, overlay: () {}),
                      RecipeCard(title: 'Chocolate Pancakes', review:3.4, image: 'https://picsum.photos/200/300', isReview: true, overlay: () {}),

                    ]
                  )
                )     
              ],
            )
          ),
        ]  
      ),
    );
  }
}