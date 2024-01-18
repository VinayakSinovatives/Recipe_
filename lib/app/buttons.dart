import 'package:reciperator/app/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';

enum ButtonType {
  back,
  contin,
  add,
  write,
  speak,
  find,
  review,
  redirect,
  scan
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.type,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  final ButtonType type;
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.back:
        return FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: onPressed,
          label: Text(label),
          icon: const Icon(CustomIcons.BackIcon),
        );
      case ButtonType.add:
        return FloatingActionButton.extended(
          backgroundColor: AppColors.secondary,
          onPressed: onPressed,
          label: Text(label, style: const TextStyle(color: AppColors.white)),
          icon: const Icon(Icons.add, color: AppColors.white),
        );
      case ButtonType.write:
        return FloatingActionButton.extended(
          backgroundColor: AppColors.secondary,
          onPressed: onPressed,
          label: Text(label, style: const TextStyle(color: AppColors.white)),
          icon: const Icon(Icons.mode_edit, color: AppColors.white),
        );
      case ButtonType.speak:
        return FloatingActionButton.extended(
          backgroundColor: AppColors.secondary,
          onPressed: onPressed,
          label: Text(label, style: const TextStyle(color: AppColors.white)),
          icon: const Icon(Icons.mic, color: AppColors.white),
        );
      case ButtonType.find:
        return FloatingActionButton.extended(
          backgroundColor: AppColors.secondary,
          onPressed: onPressed,
          label: Text(label, style: const TextStyle(color: AppColors.white)),
        );
      case ButtonType.contin:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.onPrimary,
            foregroundColor: AppColors.primary,
          ),
          child: Text(label),
        );
      case ButtonType.review:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.onPrimary,
              side: const BorderSide(color: AppColors.onPrimary)),
          child: Text(label),
        );
      case ButtonType.redirect:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.onPrimary,
            foregroundColor: AppColors.primary,
          ),
          child: Text(label),
        );
      case ButtonType.scan:
        return FloatingActionButton.extended(
          backgroundColor: AppColors.secondary,
          onPressed: onPressed,
          label: Text(label, style: const TextStyle(color: AppColors.white)),
        );
      default:
        return TextButton(
          onPressed: onPressed,
          child: const Text('Wrong type'),
        );
    }
  }
}
