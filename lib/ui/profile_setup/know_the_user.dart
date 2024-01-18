import 'package:reciperator/routes/router_constants.dart';
import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/app/text_images.dart';
import 'package:reciperator/ui/profile_setup/food_images.dart';
import 'package:reciperator/ui/profile_setup/food_titles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KnowTheUser extends StatefulWidget {
  const KnowTheUser({super.key});

  @override
  State<KnowTheUser> createState() => _KnowTheUserState();
}

class _KnowTheUserState extends State<KnowTheUser> {
  late OverlayEntry overlayEntry;

  void _hideOverlay(OverlayEntry overlayEntry1) {
    overlayEntry1.remove();
  }

  void _showOverlay(BuildContext context, int category, List<ImageWithText> helper) async {
    List<String> titles = allTitles(category);
    List<String> images = allImages(category);
    OverlayState? overlayState = Overlay.of(context);

    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned.fill(
          child: GestureDetector(
              onTap: () {},
              // the following screen dictates that the screen darkens a bit when the overlay appears
              // and determines the position of the buttons, according to Figma
              child: Container(
                  color: Colors.black.withOpacity(0.9),
                  width: 249,
                  height: 467,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Positioned(
                          width: MediaQuery.of(context).size.width / 2,
                          top: 100,
                          left: MediaQuery.of(context).size.width / 4,
                          child: const DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                            maxLines: 3,
                            child: Text(
                              'Choose your favorite dishes',
                              textAlign: TextAlign.center,
                            ),
                          )),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 467,
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    4, // Number of items in each row
                                crossAxisSpacing:
                                    8.0, // Spacing between columns
                                mainAxisSpacing: 20.0, // Spacing between rows
                              ),
                              itemCount: images.length,
                              itemBuilder: (BuildContext context, int index) {
                                ImageWithText aux = ImageWithText(
                                  title: titles[index],
                                  image: images[index],
                                  onTap: () {},
                                  color: Colors.white,
                                  enableHighlight: true,
                                  category: category-1, index:index
                                );
                                helper.add(aux);
                                return aux;
                              }),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Button(
                            type: ButtonType.contin,
                            label: 'Back',
                            onPressed: () {
                              _hideOverlay(overlayEntry);
                            },
                          )),
                    ],
                  ))));
    });

    overlayState.insertAll([overlayEntry]);
  }

  @override
  Widget build(BuildContext context) {
    List<ImageWithText> helper = [];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.background,
        ))),
        Positioned(
          top: 80,
          left: MediaQuery.of(context).size.width / 2 - 123,
          width: 246,
          child: const Center(
            child: Text('Welcome to Reciperator!',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center),
          ),
        ),
        Positioned(
            top: 185,
            left: MediaQuery.of(context).size.width / 2 - 120,
            width: 240,
            child: const Center(
                child: Text(
                    'Complete this short survey to help us recommend dishes according to your tastes',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center))),
        Positioned(
            top: 320,
            left: MediaQuery.of(context).size.width / 2 - 120,
            width: 245,
            child: const Center(
                child: Text('What is your favorite cuisine?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center))),
        Positioned(
            bottom: 209,
            left: MediaQuery.of(context).size.width / 2 - 52,
            child: Button(
              type: ButtonType.contin,
              label: 'Continue',
              onPressed: () async {
                takingdata(helper);
                Navigator.pushReplacementNamed(context, homeRoute);
              },
            )),
        Positioned(
            bottom: 300,
            child: Container(
                height: 130.0,
                width: 353.0,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ImageWithText(
                        title: '🇯🇵',
                        image:
                            "https://cdn.media.amplience.net/i/japancentre/Blog-page-156-sushi/Blog-page-156-sushi?\$poi\$&w=556&h=391&sm=c&fmt=auto",
                        onTap: () {
                          _showOverlay(context, 1, helper);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ImageWithText(
                        title: '🇮🇳',
                        image:
                            "https://www.thespruceeats.com/thmb/htgE7CCYS5FaW99oF183gVl7e_Q=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-639389404-5c450e724cedfd00015b09d5.jpg",
                        onTap: () {
                          _showOverlay(context, 2, helper);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ImageWithText(
                        title: '🇮🇹',
                        image:
                            "https://www.hotelmousai.com/blog/wp-content/uploads/2021/12/Top-10-Traditional-Foods-in-Italy.jpg",
                        onTap: () {
                          _showOverlay(context, 3, helper);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ImageWithText(
                        title: '🇸🇦',
                        image:
                            "https://images.yummy.ph/yummy/uploads/2022/05/chickenkabsa.jpg",
                        onTap: () {
                          _showOverlay(context, 4, helper);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ImageWithText(
                        title: '🇩🇪',
                        image:
                            "https://atasteofabroad.com/wp-content/uploads/2021/06/pretzel-541738_640.jpg",
                        onTap: () {
                          _showOverlay(context, 5, helper);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ImageWithText(
                        title: '🇨🇳',
                        image:
                            "https://www.recipetineats.com/wp-content/uploads/2023/06/Chili-crisp-noodles_2.jpg?w=747&h=747&crop=1",
                        onTap: () {
                          _showOverlay(context, 6, helper);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ImageWithText(
                        title: '🇬🇷',
                        image:
                            "https://s3.ivisa.com/website-assets/blog/best-greek-food.webp",
                        onTap: () {
                          _showOverlay(context, 7, helper);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ImageWithText(
                        title: '🇲🇽',
                        image:
                            "https://hips.hearstapps.com/hmg-prod/images/gorditas-2-1676665008.jpg",
                        onTap: () {
                          _showOverlay(context, 8, helper);
                        }),
                  )
                ]))),
        Positioned(
          top: 40, // adjust the position as needed
          right: 20, // adjust the position as needed
          child: TextButton(
            onPressed: () {
              // Define what happens when the user taps "Skip"
              // For example, navigate to the next screen
              Navigator.pushNamed(context, homeRoute);
            },
            child: Text(
              'Skip',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

Future<void> takingdata(List<ImageWithText>? helper) async {
  //The list which will keep the data
  List<String> keeper;
  keeper = [];

  if (helper != null) {
    //traversing and checking, if isHighlighted is true then it is selected
    for (ImageWithText widget in helper) {
      if (widget.isHighlighted) {
        keeper.add(widget.title);
      }
    }
  }

  CollectionReference recipes =
      FirebaseFirestore.instance.collection('recipes');
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('food').get();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  for (String titling in keeper) {
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      //checking which recipes have the same title as thos the user selected
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      if (data['title'].contains(titling)) {
        await recipes.doc().set({
          'image': data['image'],
          'link': data['link'],
          'review': 0,
          'title': data['title'],
          'user_id': uid
        });
      }
    }
  }
}
