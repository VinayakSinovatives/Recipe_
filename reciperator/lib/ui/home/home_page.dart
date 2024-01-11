import 'package:reciperator/routes/router_constants.dart';
import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/ui/home/menu.dart';
import 'package:reciperator/app/recipe_card.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';



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

class _HomePageState extends State<HomePage> {

  
  late OverlayEntry overlayEntry1;
  late OverlayEntry overlayEntry2;
  //the following overlay replaces the "add ingredient" button with the choices to either
  //add via keyboard/microphone or via camera 

  void _hideOverlay(OverlayEntry overlayEntry1) {
    overlayEntry1.remove();
  }
  void _hideReviewOverlay(OverlayEntry overlayEntry2) {
  overlayEntry2.remove();
  }

  double rating = 0.0;
  double prev_rating = 0.0;
  void reviewOverlay (BuildContext context) async{
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
    overlayState2.insertAll([overlayEntry2]); 

  }
  void _showOverlay(BuildContext context) async {

    OverlayState? overlayState = Overlay.of(context);

    overlayEntry1 = OverlayEntry(builder: (context) {
      return Positioned.fill(
        child:GestureDetector(

          onTap: () {_hideOverlay(overlayEntry1);},
          //the following screen dictates that the screen darkens a bit when the overlay appears 
          //and determines the position of the buttons, according to Figma 
          child: Container(
            color: Colors.black.withOpacity(0.8),
            child: Stack(
              children: [
                Positioned(
                  left: 71.0, 
                  bottom: 200.0,
                  child: Button(type: 'Add', label:'Add', onPressed: () {
                    _hideOverlay(overlayEntry1);
                    Navigator.pushNamed(context, addIngredientsRoute);
                    },),
                ), 
                Positioned(
                  right: 67.0, 
                  bottom: 200.0,
                  child: Button(type: 'Add', label:'Scan', onPressed: () {},),
                ),
              ],
            )
          ) 
        )
      );
    });

    isOverlayVisible = true; 
    debugPrint('Overlay appeared, flag is $isOverlayVisible, it must be true');
    overlayState.insertAll([overlayEntry1]); 
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.title, 
          style: const TextStyle(fontSize: 30)
        ),
        backgroundColor: Colors.transparent,
      ), 
      backgroundColor: Colors.transparent,
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
          const Positioned(
            left: 11, 
            top: 146,
            child: Text(
                  "You'll love these...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  )
                ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:17, top: 178),
                  child: Row(
                    children: [ 
                      RecipeCard(title: 'Spanish Tortillas', review: 4.0, image: 'https://picsum.photos/200/300', overlay: () {reviewOverlay(context);}),
                      RecipeCard(title: 'Chocolate Pancakes', review:3.4, image: 'https://picsum.photos/200/300', overlay: () {reviewOverlay(context);}),
                    ]
                  )
                )     
              ],
            )
          ),
          Positioned(
            bottom: 90.0,  
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'You have no idea what to eat?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    )
                  )
                ),
                Button (type: 'Add', label:'Add Ingredients', onPressed: () {_showOverlay(context);},),
              ],
            )
          )
        ]  
      ),
    );
  }
}