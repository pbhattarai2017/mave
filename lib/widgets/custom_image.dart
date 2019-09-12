import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String imagePath;
  CustomImage(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.0,
      height: 80.0,
      child: Image.asset(this.imagePath),
    );
  }
}
