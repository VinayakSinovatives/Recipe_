import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  bool deleted;
  CustomTextField({super.key, required this.controller, required this.focusNode, required this.deleted});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkShowClearButton);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkShowClearButton);
    widget.controller.dispose();
    super.dispose();
  }

  void _checkShowClearButton() {
    setState(() {
      _showClearButton = widget.controller.text.isNotEmpty;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330, 
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ), 
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 36.0, left: 8.0),
            child: TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              decoration: const InputDecoration(
                hintText: 'Your text here',
                border: InputBorder.none,
              ),
            ),
          ),
          if (_showClearButton) 
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  widget.controller.clear();
                  widget.deleted = true;
                });
              },
            )
          
        ],
      )
    );
  }
}