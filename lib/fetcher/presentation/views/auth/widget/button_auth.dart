import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class ButtonAuth extends StatelessWidget {
  const ButtonAuth({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        iconColor: Colors.red,
        minimumSize: const Size(200, 50),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      label: Text(
        title,
        style: GoogleFonts.pragatiNarrow(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
