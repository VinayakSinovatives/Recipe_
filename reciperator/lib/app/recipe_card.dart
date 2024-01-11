import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/app/buttons.dart';

// ignore: must_be_immutable
class RecipeCard extends StatelessWidget {
  RecipeCard({
    super.key,
    required this.title,
    required this.review,
    required this.image,
    required this.overlay,
    this.isReview = false,
    });

    final String title;
    final double review;
    final String image;
    final VoidCallback overlay;
    bool isReview;

  @override
  Widget build(BuildContext context) {
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
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Text(
              !isReview ? '$review/5' : 'My Review: $review/5',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              )
            ),
          ), 
          Container(
            width: double.infinity,
            height: 208,
            child: Image.network(image, fit: BoxFit.cover,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Button(type: 'Review', label: !isReview ? 'Review' : 'Write Review', onPressed: overlay),
              ),
              Padding( 
                padding: const EdgeInsets.all(4.0),
                child: Button(type: 'Redirect', label: 'Check it out', onPressed: () {}),
              ), 
            ],
          )
        ],
      )
    );
  }
}