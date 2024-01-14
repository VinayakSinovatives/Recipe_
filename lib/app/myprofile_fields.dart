import 'package:flutter/material.dart';

class ProfileCustomTextfield extends StatefulWidget {
  const ProfileCustomTextfield({
    Key? key,
    required this.text,
    required this.width,
    required this.mycontroller,
  }) : super(key: key);

  final String text;
  final double width;
  final TextEditingController mycontroller;

  @override
  _ProfileCustomTextfieldState createState() => _ProfileCustomTextfieldState();
}

class _ProfileCustomTextfieldState extends State<ProfileCustomTextfield> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEditing = true;
          widget.mycontroller.text = widget.text; // Set initial text when editing starts
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Display the Text widget when not editing
          Visibility(
            visible: !isEditing,
            child: Container(
              width: 2 / 3 * widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  widget.text,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          // Display the TextFormField when editing
          Visibility(
            visible: isEditing,
            child: Container(
              width: 2 / 3 * widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey[200],
              ),
              child: TextFormField(
                controller: widget.mycontroller,
                autofocus: true,
                onFieldSubmitted: (value) {
                  setState(() {
                    isEditing = false;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
