import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/ui/home/menu.dart';
import 'package:reciperator/app/recipe_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reciperator/app/test_app.dart';
import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/routes/router_constants.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';

class MyReviews extends StatefulWidget {
  const MyReviews({super.key});

  @override
  State<MyReviews> createState() => _MyReviewsState();
}

bool isReviewOverlayVisible = false;

class _MyReviewsState extends State<MyReviews> {
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
  
  Future<List<RecipeCard>?> findingreviews() async{
    //First extracting all the recommendations related to this user
    FirebaseAuth auth = FirebaseAuth.instance;
    List<RecipeCard> reviews = [];
    User? user = auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('user_id', isEqualTo: uid)
        .get();

        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          if(data['review'] > 0){
            RecipeCard aux = RecipeCard(title: data['title'], review: data['review'], image: data['image'], 
            overlay: () {reviewOverlay(context, data['image'], data['review'].toDouble(), data['title'], uid, data['link']);}, link: data['link'], isReview: true);
            reviews.add(aux);
          }

        }
        
      }

    return  reviews;
  }

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
      body: PopScope(
        canPop: true,
        onPopInvoked: (bool didPop) {
          if (isReviewOverlayVisible) {
            _hideReviewOverlay(overlayEntry2);
          }
        },
        child: FutureBuilder<List<RecipeCard>?>(
          future: findingreviews(),
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
                  'No reviews yet.',
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
                  SingleChildScrollView(
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
                ]  
              );
            }
          }
        ),
      ) 
    );
  }
}