import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/routes/router_constants.dart';
import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/ui/home/menu.dart';
import 'package:reciperator/app/recipe_card.dart';
import 'package:reciperator/app/test_app.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Recipes extends StatefulWidget {
  final List<QueryDocumentSnapshot>? results;
  const Recipes({super.key, required this.results});

  @override
  State<Recipes> createState() => _RecipesState();
}

bool isReviewOverlayVisible = false;

class _RecipesState extends State<Recipes> {
  late OverlayEntry overlayEntry2;
  void _hideReviewOverlay(OverlayEntry overlayEntry2) {
  overlayEntry2.remove();
  isReviewOverlayVisible = false;
  }

  double rating = 0.0;
  double prev_rating = 0.0;
  void reviewOverlay (BuildContext context, String image, double review, String title, String uid, String link) async{
    OverlayState? overlayState2 = Overlay.of(context);

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
                    const SizedBox(height:15),
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
                      onChanged: (value) {
                         // the rating value is updated on tap or drag.
                        setState(() {
                          prev_rating = rating;
                          rating = value;
                          _hideReviewOverlay(overlayEntry2);
                          reviewOverlay(context, image, review, title, uid, link);
                        });
                      },
                    ),
                    const SizedBox(height:20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(type: ButtonType.redirect, label: 'Save', onPressed: () async {
                          //Create review and insert it in database
                          await reviewfun(image, rating, title, uid, link);
                          _hideReviewOverlay(overlayEntry2);
                          Navigator.pushNamed(context, reviewRoute);
                        }),
                        const SizedBox(width:28),
                        Button(type: ButtonType.review, label: 'Cancel', onPressed: () {
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
    isReviewOverlayVisible = true;
    overlayState2.insertAll([overlayEntry2]); 

  }

  Future<List<RecipeCard>?> takingresults() async {
    List<RecipeCard>? toreturn = [];
    //Checking if a recipe is in user
    for(QueryDocumentSnapshot document in widget.results!){
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      RecipeCard? aux;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('user_id', isEqualTo: uid)
        .where('link', isEqualTo: data['link'])
        .get();

      //If it is in this user
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic> datanew = document.data() as Map<String, dynamic>;
          aux = RecipeCard(title: datanew['title'], review: datanew['review'].toDouble(), image: datanew['image'],
             overlay: () {reviewOverlay(context, datanew['image'], datanew['review'].toDouble(), datanew['title'], uid, datanew['link']);}, link: datanew['link'], isReview: datanew['review'].toDouble() > 0 ? true : false);
          toreturn.add(aux);
          break;
        }
      }
      else{
        aux = RecipeCard(title: data['title'], review: (0.0).toDouble(), image: data['image'], 
            overlay: () {reviewOverlay(context, data['image'], 0, data['title'], uid, data['link']);}, link: data['link'], isReview: false);
        toreturn.add(aux);
      }   
    }

    return toreturn;
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
      body: PopScope(
        canPop: true, 
        onPopInvoked: (bool didPop) {
          if (isReviewOverlayVisible) {
            _hideReviewOverlay(overlayEntry2);
          }
        },
        child: FutureBuilder(
          future: takingresults(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } 
            else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } 
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return buildBackground(const Center(
                child: Text(
                  'No recipes found.',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  )
                  )
                )
              );
            } 
            else {
              List<Widget> recommendationWidgets = snapshot.data!;
        
              return Stack(
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
                                  children: recommendationWidgets
                                )
                              )     
                            ],
                          )
                        ),
                      ),
                      const SizedBox(height:20),
                      Button(type:ButtonType.find, label: 'Find Another Recipe', onPressed: () {Navigator.pushNamed(context, addIngredientsRoute);})
                    ],
                  ),
                ]  
              );
            }
          }
        ),
      ),
    );
  }
}