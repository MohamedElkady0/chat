import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/core/config/config_app.dart';

class ImageAuth extends StatelessWidget {
  const ImageAuth({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigApp.initConfig(context);
    double width = ConfigApp.width;
    return Stack(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {},
          child: CircleAvatar(
            radius: width * 0.13,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              FontAwesomeIcons.user,
              size: width * 0.10,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: -10,
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.camera,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              // Implement image picker functionality here
            },
          ),
        ),
      ],
    );
  }
}
