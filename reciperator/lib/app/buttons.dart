import 'package:reciperator/app/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.type,
    required this.label,
    required this.onPressed,
    });

    final String type;
    final String label;
    final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (type == 'Back') {
      return FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: onPressed, 
        label: Text(label), 
        icon: const Icon(CustomIcons.BackIcon),
      );
    }
    else if (type == 'Continue') {
      return ElevatedButton(
        onPressed: onPressed, 
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: Colors.black,
        ),
        child: Text(label),
      );
    }
    else if (type == 'Add'){
      return FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        onPressed: onPressed, 
        label: Text(
          label,
          style: const TextStyle(
            color: AppColors.white
          )), 
        icon: const Icon(
          Icons.add, 
          color: AppColors.white),
      );
    }
    else if (type == 'Write'){
      return FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        onPressed: onPressed, 
        label: Text(
          label,
          style: const TextStyle(
            color: AppColors.white
          )), 
        icon: const Icon(
          Icons.mode_edit, 
          color: AppColors.white),
      );
    }
    else if (type == 'Speak'){
      return FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        onPressed: onPressed, 
        label: Text(
          label,
          style: const TextStyle(
            color: AppColors.white
          )), 
        icon: const Icon(
          Icons.mic, 
          color: AppColors.white),
      );
    }
    else if (type == 'Find'){
      return FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        onPressed: onPressed, 
        label: Text(
          label,
          style: const TextStyle(
            color: AppColors.white
          )), 
        
      );
    }
    else if (type == 'Review'){
      return ElevatedButton(
        onPressed: onPressed, 
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.onPrimary,
          side: const BorderSide(color: AppColors.onPrimary)
        ),
        child: Text(label),
      );
    }
    else if (type == 'Redirect'){
      return ElevatedButton(
        onPressed: onPressed, 
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.onPrimary,
          foregroundColor: AppColors.primary,
        ),
        child: Text(label),
      );
    }
    return TextButton(
      onPressed: onPressed,
      child: const Text('Wrong type'), 
    );
  }
}