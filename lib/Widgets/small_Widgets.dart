// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPassTextField extends StatefulWidget {
  dynamic node;
  TextEditingController controller;
  dynamic isclicked;
  String error = '';
  UserPassTextField(
      {super.key,
      required this.node,
      required this.controller,
      required this.isclicked,
      required this.error});

  @override
  State<UserPassTextField> createState() => _UserPassTextFieldState();
}

class _UserPassTextFieldState extends State<UserPassTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
          cursorColor: Colors.black,
          style: GoogleFonts.cabin(
            textStyle: const TextStyle(),
          ),
          focusNode: widget.node,
          controller: widget.controller,
          autocorrect: true,
          obscureText: widget.isclicked,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 15),
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  widget.isclicked = !widget.isclicked;
                });
              },
              child: Icon(
                widget.isclicked
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye,
                size: 22,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(50),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(50),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors
                      .white), // Change this color to your preferred focused border color
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return widget.error;
            }
            return null;
          }),
    );
  }
}

class UserTextField extends StatefulWidget {
  dynamic node;
  TextEditingController controller;
  String error = '';
  UserTextField(
      {super.key,
      required this.node,
      required this.controller,
      required this.error});

  @override
  State<UserTextField> createState() => _UserTextFieldState();
}

class _UserTextFieldState extends State<UserTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(widget.node);
                              },
          cursorColor: Colors.black,
          style: GoogleFonts.cabin(
            textStyle: const TextStyle(),
          ),
          focusNode: widget.node,
          controller: widget.controller,
          autocorrect: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 15),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(50),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(50),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors
                      .white), // Change this color to your preferred focused border color
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return widget.error;
            }
            return null;
          }),
    );
  }
}