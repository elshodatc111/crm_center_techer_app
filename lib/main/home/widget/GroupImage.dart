import 'package:flutter/material.dart';
class Groupimage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/images/new.png',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

