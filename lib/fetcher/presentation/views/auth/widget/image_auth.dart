import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageAuth extends StatelessWidget {
  const ImageAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {},
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[800],
            child: Icon(FontAwesomeIcons.user, size: 50, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            icon: Icon(FontAwesomeIcons.camera, color: Colors.black),
            onPressed: () {
              // Implement image picker functionality here
            },
          ),
        ),
      ],
    );
  }
}
