import 'package:flutter/material.dart';

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.5,
        0,
        size.height * 0.75,
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
