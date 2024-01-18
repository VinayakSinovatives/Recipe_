import 'package:reciperator/app/colors.dart';
import 'package:reciperator/ui/profile_setup/food_flags.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageWithText extends StatefulWidget {
  ImageWithText({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
    this.category = 0, 
    this.index = 0,
    this.color = Colors.black,
    this.enableHighlight = false,
    this.isHighlighted = false,
    });

    final String title;
    final String image;
    final VoidCallback onTap;
    int category;
    int index;
    bool enableHighlight;
    bool isHighlighted;
    final Color color;

    @override
    State<ImageWithText> createState() => _ImageWithTextState();

}
class _ImageWithTextState extends State<ImageWithText>{

  @override 
  void initState() {
    super.initState();
    widget.isHighlighted = widget.enableHighlight ? allFlags[widget.category][widget.index] : false;
  }
  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: widget.enableHighlight
          ? () {
              debugPrint("Flag is ${widget.isHighlighted}");
              setState(() {
                widget.isHighlighted = !widget.isHighlighted;
                allFlags[widget.category][widget.index] = !allFlags[widget.category][widget.index];
              });
              widget.onTap();
              debugPrint("Flag is ${widget.isHighlighted}");
              
            }
          : widget.onTap,
      child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: 50.0, // Adjust the width as needed
            height: 50.0, // Adjust the height as needed
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isHighlighted ? AppColors.primary : Colors.transparent,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(100.0),
              image: DecorationImage(
                image: NetworkImage(widget.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          DefaultTextStyle(style: TextStyle(fontSize: 12.0, color: widget.color,fontWeight: FontWeight.bold), child: Text(widget.title)),
        ],
      ),
      ),
    );
  }
}