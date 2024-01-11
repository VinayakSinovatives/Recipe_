import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/routes/router_constants.dart';
import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/ui/home/menu.dart';
import 'package:reciperator/app/recipe_card.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';

class Recipes extends StatefulWidget {
  const Recipes({super.key});

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  late OverlayEntry overlayEntry2;
  void _hideReviewOverlay(OverlayEntry overlayEntry2) {
    overlayEntry2.remove();
  }
  double prev_rating = 0.0;
  double rating = 0.0;
  void reviewOverlay (BuildContext context) async{
    OverlayState? overlayState = Overlay.of(context);

    overlayEntry2 = OverlayEntry(builder: (context) {

      return GestureDetector(
        onTap: () {}, 
        child: Stack(
          children: [
            Container(
              color: Colors.black.withOpacity(0.9),
            ), 
            Center(
              child: Container(
                
                decoration: BoxDecoration(
                  color: AppColors.black, 
                  borderRadius: BorderRadius.circular(15.0), 
                ),
                height: 167,
                width: 300,
                child: Column(
                  children: [
                    const SizedBox(height:5),
                    const DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      child: Text('Rate this recipe:',),
                    ),
                    const SizedBox(height:10),
                    PannableRatingBar(
                      rate: rating,
                      items: List.generate(5, (index) =>
                        const RatingWidget(
                          selectedColor: Colors.yellow,
                          unSelectedColor: Colors.grey,
                          child: Icon(
                            Icons.star,
                            size: 48,
                          ),
                        )),
                      onHover: (value) { // the rating value is updated on tap or drag.
                        setState(() {
                          prev_rating = rating;
                          rating = value;
                          _hideReviewOverlay(overlayEntry2);
                          reviewOverlay(context);
                        });
                      },
                    ),
                    const SizedBox(height:20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(type: 'Redirect', label: 'Save', onPressed: () {_hideReviewOverlay(overlayEntry2);}),
                        const SizedBox(width:28),
                        Button(type: 'Review', label: 'Cancel', onPressed: () {
                          _hideReviewOverlay(overlayEntry2);
                          rating = prev_rating;
                          })
                      ],
                    )
                  ],
                )
              ),
            )
          ],
        ),
          
        
      );
    });
    overlayState.insertAll([overlayEntry2]); 

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Available Recipes", 
          style: TextStyle(fontSize: 30)
        ),
        backgroundColor: AppColors.green,
      ), 
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
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 700,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:26, top: 138),
                        child: Column(
                          children: [ 
                            RecipeCard(title: 'Spanish Tortillas', review: 4.0, image: 'https://picsum.photos/200/300', isReview: true, overlay: () {reviewOverlay(context);}),
                            RecipeCard(title: 'Chocolate Pancakes', review:3.4, image: 'https://picsum.photos/200/300', isReview: true, overlay: () {reviewOverlay(context);}),
                            RecipeCard(title: 'Chocolate Pancakes', review:3.4, image: 'https://picsum.photos/200/300', isReview: true, overlay: () {reviewOverlay(context);}),
                
                          ]
                        )
                      )     
                    ],
                  )
                ),
              ),
              const SizedBox(height:20),
              Button(type: 'Find', label: 'Find Another Recipe', onPressed: () {Navigator.pushNamed(context, addIngredientsRoute);})
            ],
          ),
        ]  
      ),
    );
  }
}