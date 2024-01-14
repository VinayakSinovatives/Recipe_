import 'package:reciperator/app/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';

enum ButtonType { back, contin, add, write, speak, find, review, redirect }

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
      case ButtonType.add:
      case ButtonType.write:
      case ButtonType.speak:
      case ButtonType.find:
        return _buildFloatingActionButton(
          label: label,
          icon: icon ?? Icons.add, // default icon
          backgroundColor: backgroundColor ?? AppColors.secondary,
        );
      case ButtonType.contin:
      case ButtonType.review:
      case ButtonType.redirect:
        return _buildElevatedButton(label);
      default:
        return TextButton(
          onPressed: onPressed,
          child: const Text('Wrong type'),
        );
    }
  }

  Widget _buildFloatingActionButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return FloatingActionButton.extended(
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      label: Text(label, style: TextStyle(color: AppColors.white)),
      icon: Icon(icon, color: AppColors.white),
    );
  }

  Widget _buildElevatedButton(String label) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.transparent,
        foregroundColor: foregroundColor ?? AppColors.onPrimary,
        side: borderColor != null ? BorderSide(color: borderColor!) : null,
      ),
      child: Text(label),
    );
  }
}
