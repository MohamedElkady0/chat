import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/core/config/fixed_sizes_app.dart';

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
    ConfigApp.initConfig(context);
    double height = ConfigApp.height;
    double width = ConfigApp.width;

    return ElevatedButton.icon(
      icon: Icon(
        icon,
        size: Theme.of(context).iconTheme.size,
        color: Theme.of(context).colorScheme.onPrimaryFixed,
      ),
      style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
        padding: WidgetStateProperty.all(AppSpacing.horizontalXS),
        maximumSize: WidgetStateProperty.all(Size(width * 1, height * 0.2)),
        minimumSize: WidgetStateProperty.all(Size(width * 0.5, height * 0.1)),
        backgroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.primary.withAlpha(50),
        ),
      ),
      onPressed: onPressed,
      label: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
