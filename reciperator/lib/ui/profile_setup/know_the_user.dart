import 'package:reciperator/routes/router_constants.dart';
import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/app/text_images.dart';
import 'package:reciperator/ui/profile_setup/food_images.dart';
import 'package:reciperator/ui/profile_setup/food_titles.dart';


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
  void _showOverlay(BuildContext context, int category) async {
    List<String> titles = allTitles(category);
    List<String> images = allImages(category);
    OverlayState? overlayState = Overlay.of(context);

    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned.fill(
        child:GestureDetector(

          onTap: () {},
          //the following screen dictates that the screen darkens a bit when the overlay appears 
          //and determines the position of the buttons, according to Figma 
          child: Container(
            color: Colors.black.withOpacity(0.9),
            width: 249, 
            height: 467,
            alignment: Alignment.center, 
            child: Stack(
              children: [
                Positioned(
                  width: MediaQuery.of(context).size.width/2,  
                  top: 100,
                  left: MediaQuery.of(context).size.width/4,
                  child:const DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 24,
                    ),
                    maxLines: 3,
                    child: Text(
                      'Choose your favorite dishes',
                      textAlign: TextAlign.center,
                    ),
                  )
                ),                 
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width, 
                    height: 467,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Number of items in each row
                        crossAxisSpacing: 8.0, // Spacing between columns
                        mainAxisSpacing: 20.0, // Spacing between rows
                      ),
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ImageWithText(title: titles[index], image: images[index], onTap: () {}, color: Colors.white, enableHighlight: true,);
                      }
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Button (type: 'Continue', label:'Back', onPressed: () {_hideOverlay(overlayEntry);},)
                ),
              ],
            )
          ) 
        )
      );
    });
    
    overlayState.insertAll([overlayEntry]); 

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      extendBodyBehindAppBar: true,
      
      backgroundColor: Colors.transparent,
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
          Positioned(
            top: 80, 
            left: MediaQuery.of(context).size.width/2-123,
            width: 246,
            child:const Center(
              child:Text(
              'Welcome to Reciperator!',
                style: TextStyle(
                  fontSize: 32.0, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center
              ),
            ),
            
          ),
          Positioned(
            top: 185, 
            left: MediaQuery.of(context).size.width/2-120, 
            width: 240,
            child:const Center(
              child: Text(
                'Complete this short survey to help us recommend dishes according to your tastes',
                style:TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                maxLines: 3, 
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center
              )
            ) 
          ),
          Positioned(
            top: 320, 
            left: MediaQuery.of(context).size.width/2-120, 
            width: 245,
            child:const Center(
              child: Text(
                'What is your favorite cuisine?',
                style:TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center
              )
            ) 
          ),
          Positioned(
            bottom: 209, 
            left: MediaQuery.of(context).size.width/2-52, 
            child: Button (type: 'Continue', label:'Continue', onPressed: () {Navigator.pushNamed(context, homeRoute);},)
          ), 
          Positioned(
            bottom: 300,
            child: Container(
              height: 130.0,
              width: 353.0, 
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ImageWithText(title:'Japanese', image: "https://picsum.photos/200/300", onTap: () {_showOverlay(context, 1);}), 
                  ImageWithText(title:'Indian', image: "https://picsum.photos/200/300", onTap: () {_showOverlay(context, 2);}),
                  ImageWithText(title:'Mediterranean', image: "https://picsum.photos/200/300", onTap: () {_showOverlay(context, 3);}),
                  ImageWithText(title:'Arabic', image: "https://picsum.photos/200/300", onTap: () {_showOverlay(context, 4);}),
                  ImageWithText(title:'German', image: "https://picsum.photos/200/300", onTap: () {_showOverlay(context, 5);}),
                  ImageWithText(title:'Chinese', image: "https://picsum.photos/200/300", onTap: () {_showOverlay(context, 6);}),
                  ImageWithText(title:'Greek', image: "https://picsum.photos/200/300", onTap: () {_showOverlay(context, 7);}),
                ]
              )
            )
          )
        ]  
      ),
    );
  }
}
