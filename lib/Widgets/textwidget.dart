import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TextWidget extends StatelessWidget {
  String text = '';
  FontWeight fontWeight;
  double size;
  Color color;

  TextWidget(
      {super.key,
      required this.text,
      required this.fontWeight,
      required this.size,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.cabin(
            textStyle: TextStyle(
                fontWeight: fontWeight, fontSize: size, color: color)));
  }
}
