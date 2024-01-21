//import 'dart:js_interop';
import 'package:reciperator/routes/router_constants.dart';
import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/ui/home/menu.dart';
import 'package:reciperator/app/recipe_card.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reciperator/app/test_app.dart';
import 'dart:math';
import 'package:reciperator/app/camera.dart';
import 'package:camera/camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.title = 'Welcome, User!',
  });

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

bool isOverlayVisible = false;
bool isReviewOverlayVisible = false;

class _HomePageState extends State<HomePage> {
  late OverlayEntry overlayEntry1;
  late OverlayEntry overlayEntry2;
  //the following overlay replaces the "add ingredient" button with the choices to either
  //add via keyboard/microphone or via camera

  void _hideOverlay(OverlayEntry overlayEntry1) {
    overlayEntry1.remove();
    isOverlayVisible = false;
  }

  void _hideReviewOverlay(OverlayEntry overlayEntry2) {
    overlayEntry2.remove();
    isReviewOverlayVisible = false;
  }

  double rating = 0.0;
  double prev_rating = 0.0;
  void reviewOverlay(BuildContext context, String image, double review,
      String title, String uid, String link) async {
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
                      const SizedBox(height: 5),
                      const DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        child: Text(
                          'Rate this recipe:',
                        ),
                      ),
                      const SizedBox(height: 15),
                      PannableRatingBar(
                        rate: rating,
                        items: List.generate(
                            5,
                            (index) => const RatingWidget(
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
                            reviewOverlay(
                                context, image, review, title, uid, link);
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Button(
                              type: ButtonType.review,
                              label: 'Save',
                              onPressed: () async {
                                //Create review and insert it in database
                                await reviewfun(
                                    image, rating, title, uid, link);
                                _hideReviewOverlay(overlayEntry2);
                                Navigator.pushNamed(context, reviewRoute);
                              }),
                          const SizedBox(width: 28),
                          Button(
                              type: ButtonType.review,
                              label: 'Cancel',
                              onPressed: () {
                                _hideReviewOverlay(overlayEntry2);
                                rating = prev_rating;
                              })
                        ],
                      )
                    ],
                  )),
            )
          ],
        ),
      );
    });
    isReviewOverlayVisible = true;
    overlayState2.insertAll([overlayEntry2]);
  }

  void _showOverlay(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);

    overlayEntry1 = OverlayEntry(builder: (context) {
      return Positioned.fill(
          child: GestureDetector(
              onTap: () {
                _hideOverlay(overlayEntry1);
              },
              //the following screen dictates that the screen darkens a bit when the overlay appears
              //and determines the position of the buttons, according to Figma
              child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 71.0,
                        bottom: 200.0,
                        child: Button(
                          type: ButtonType.add,
                          label: 'Add',
                          onPressed: () {
                            _hideOverlay(overlayEntry1);
                            Navigator.pushNamed(context, addIngredientsRoute);
                          },
                        ),
                      ),
                      Positioned(
                        right: 67.0,
                        bottom: 200.0,
                        child: Button(
                          type: ButtonType.scan,
                          label: 'Scan',
                          onPressed: () async {
                            final cameras = await availableCameras();
                            final firstCamera = cameras.first;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TakePictureScreen(
                                        camera: firstCamera)));
                            _hideOverlay(overlayEntry1);
                          },
                        ),
                      ),
                    ],
                  ))));
    });

    isOverlayVisible = true;
    debugPrint('Overlay appeared, flag is $isOverlayVisible, it must be true');
    overlayState.insertAll([overlayEntry1]);
  }

  Future<List<RecipeCard>?> findingrecommendations() async {
    //First extracting all the recommendations related to this user
    FirebaseAuth auth = FirebaseAuth.instance;
    debugPrint("here ok");
    List<RecipeCard> recommendations = [];
    User? user = auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .where('user_id', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String titler = data['title'];
        double reviewr = (data['review'] as num).toDouble();
        String imager = data['image'];
        String linkr = data['link'];
        RecipeCard aux = RecipeCard(
            title: titler,
            review: reviewr,
            image: imager,
            overlay: () {
              reviewOverlay(context, imager, reviewr, titler, uid, linkr);
            },
            link: linkr,
            isReview: reviewr > 0 ? true : false);

        recommendations.add(aux);
      }

      //checking associations
      Set<int> randomList = {};
      //if there are enough
      if (recommendations.length >= 5) {
        while (randomList.length < 5) {
          randomList.add(Random().nextInt(recommendations.length));
        }
      }
      //if not enough, export from database randomly
      else {
        QuerySnapshot querySnapshotnew =
            await FirebaseFirestore.instance.collection('food').get();
        for (QueryDocumentSnapshot document in querySnapshotnew.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String titler = data['title'];
          String imager = data['image'];
          String linkr = data['link'];
          RecipeCard aux = RecipeCard(
              title: titler,
              review: 0,
              image: imager,
              overlay: () {
                reviewOverlay(context, imager, 0, titler, uid, linkr);
              },
              link: linkr,
              isReview: false);

          recommendations.add(aux);
        }

        while (randomList.length < 5) {
          randomList.add(Random().nextInt(recommendations.length));
        }
      }
      //finally, take the randoms
      List<RecipeCard> endgame = [];
      for (int i in randomList) {
        endgame.add(recommendations[i]);
      }
      recommendations = endgame;
    }

    return recommendations;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(widget.title, style: const TextStyle(fontSize: 30)),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        drawer: const Menu(),
        body: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (_scaffoldKey.currentState?.isDrawerOpen == true) {
              _scaffoldKey.currentState?.openEndDrawer();
            } else {
              if (isOverlayVisible) {
                _hideOverlay(overlayEntry1);
              } else if (isReviewOverlayVisible) {
                _hideReviewOverlay(overlayEntry2);
              }
              Navigator.pushNamedAndRemoveUntil(context, landing, (r) => false);
            }
          },
          child: FutureBuilder<List<RecipeCard>?>(
              future: findingrecommendations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return buildBackground(const Center(
                      child: Text('No recommendations found.',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ))));
                } else {
                  List<Widget> recommendationWidgets = snapshot.data!;

                  return Center(
                      child: Stack(children: [
                    Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: AppColors.background,
                    ))),
                    const Positioned(
                      left: 11,
                      top: 146,
                      child: Text("You'll love these...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          )),
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Stack(
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 17, top: 178),
                                child: Row(children: recommendationWidgets))
                          ],
                        )),
                    Positioned(
                        bottom: 90.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text('You have no idea what to eat?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ))),
                            Button(
                              type: ButtonType.add,
                              label: 'Add Ingredients',
                              onPressed: () {
                                _showOverlay(context);
                              },
                            ),
                          ],
                        ))
                  ]));
                }
              }),
        ));
  }
}
