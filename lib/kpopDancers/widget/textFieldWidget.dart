import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.description,
    required this.fontsize,
  }) : super(key: key);

  final String description;
  final double fontsize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        description,
        style: TextStyle(
          fontSize: fontsize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
