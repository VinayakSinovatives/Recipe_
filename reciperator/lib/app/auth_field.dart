import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.text,
    required this.width,
    required this.mycontroller,
    required this.v,
    });

    final String text;
    final double width;
    final TextEditingController mycontroller;
    final bool v;

  @override
  Widget build(BuildContext context) {
    return 
      SizedBox(
        width: 2/3*width,
        child: 
          TextField(
            obscureText: v, 
            controller: mycontroller, 
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 83, 18, 95)), // Border color for focused state
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 83, 18, 95)), // Border color for unfocused state
              ),
              hintText: text,
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            ),
          ),
      );
  }
}