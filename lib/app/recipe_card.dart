import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/app/buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class RecipeCard extends StatelessWidget {
  RecipeCard({
    super.key,
    required this.title,
    required this.review,
    required this.image,
    required this.overlay,
    required this.link,
    this.isReview = false,
    });

    final String title;
    final double review;
    final String image;
    final VoidCallback overlay;
    final String link;
    bool isReview;

    Future<double> calculateaverage() async {
      double aux = 0.0;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('link', isEqualTo: link)
        .get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        aux += data['review'];
      }

      aux /= querySnapshot.docs.length;
      aux = double.parse((aux).toStringAsFixed(2));
      
      return aux;
    } 

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: calculateaverage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } 
          else if (!snapshot.hasData) {
            return const Center(child: Text('No average found.'));
          } 
          else {
            double average = snapshot.data ?? 0;
            
            return Container(
              width: 302, 
              height: 352,
              decoration: ShapeDecoration(
                color: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              margin: const EdgeInsets.all(8),
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Text(
                      title,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Text(
                          !isReview ? '' : 'My Review: $review/5',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          )
                        ),
                      ), 
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Text(
                              average > 0 ? '$average/5' : '0/5',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              )
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(0.1),
                            child: Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 20.0, // Adjust the size as needed
                            ),
                          ),
                        ]
                      ),
                    ] 
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 208,
                    child: Image.network(image, fit: BoxFit.cover,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Button(type: ButtonType.review, label: isReview ? 'Change Review' : 'Write Review', onPressed: overlay),
                      ),
                      Padding( 
                        padding: const EdgeInsets.all(4.0),
                        child: Button(type: ButtonType.redirect, label: 'Check it out', onPressed: () async {
                          //Use "link" here to redirect to the site
                          //See this video for changes i had to do:
                          //https://www.youtube.com/watch?v=wI1IroOdVvE
                          Uri mylink = Uri.parse(link);
                            if (await canLaunchUrl(mylink)) {
                              await launchUrl(mylink);
                            } else {
                            throw 'Could not launch $link';
                            }
                        }),
                      ), 
                    ],
                  )
                ],
              )
            );
          }
      }
    );
  }
}