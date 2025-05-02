import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButton({Key? key, required this.onPressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.bold, // Optional: make the text bold
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Button color
        foregroundColor: Colors.white, // Text color
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5, // Add shadow for better visual
        shadowColor: Colors.black.withOpacity(0.3), // Subtle shadow effect
        splashFactory: InkRipple.splashFactory, // Improved splash effect on press
      ),
    );
  }
}
