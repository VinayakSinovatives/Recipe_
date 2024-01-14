import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/app/buttons.dart';

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
  final bool isReview;

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
          // ... existing code ...
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Button(
                  type: ButtonType.review, // Using enum value for button type
                  label: !isReview ? 'Review' : 'Write Review', 
                  onPressed: overlay
                ),
              ),
              Padding( 
                padding: const EdgeInsets.all(4.0),
                child: Button(
                  type: ButtonType.redirect, // Using enum value for button type
                  label: 'Check it out', 
                  onPressed: () {}
                ),
              ), 
            ],
          )
        ],
      )
    );
  }
}
