import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key, 
    required this.type, 
    required this.text,
    required this.onTap,
    }); 

    final String type; 
    final String text;
    final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (type == 'Home') {
      return ListTile(
        leading: const Icon(Icons.home, color:Colors.white), 
        title: Text(
          text, 
          style: const TextStyle(color: Colors.white)
        ), 
        onTap: onTap,
      );
    }
    else if (type == 'Profile') {
      return ListTile(
        leading: const Icon(Icons.person, color: Colors.white), 
        title: Text(
          text, 
          style: const TextStyle(color: Colors.white)
        ), 
        onTap: onTap,
      );
    }
    else if (type == 'Reviews') {
      return ListTile(
        leading: const Icon(Icons.star_border, color: Colors.white), 
        title: Text(
          text, 
          style: const TextStyle(color: Colors.white)
        ), 
        onTap: onTap,
      );
    }
    else if (type == 'MealPlanner') {
      return ListTile(
        leading: const Icon(Icons.today, color: Colors.white), 
        title: Text(
          text, 
          style: const TextStyle(color: Colors.white)
        ), 
        onTap: onTap,
      );
    }
    else if (type == 'LogOut') {
      return ListTile(
        leading: const Icon(Icons.logout, color: Colors.white), 
        title: Text(
          text, 
          style: const TextStyle(color: Colors.white)
        ), 
        onTap: onTap,
      );
    }
    return const Placeholder();
  }
}