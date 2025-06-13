import 'package:flutter/material.dart';

class InputFieldAuth extends StatelessWidget {
  const InputFieldAuth({
    super.key,
    required this.title,
    required this.icon,

    this.onSaved,
    this.keyboardType,
    required this.obscureText,
    this.controller,
    this.onPressed,
    this.onChanged,
  });

  final String title;
  final IconData icon;
  final void Function()? onPressed;
  final void Function(String?)? onSaved;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      validator: (val) {
        if (title == 'Name') {
          if (val == null || val.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        } else if (title == 'Email') {
          if (val == null || val.isEmpty) {
            return 'Please enter your email';
          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
            return 'Please enter a valid email address';
          }
          return null;
        } else if (title == 'password') {
          if (val == null || val.isEmpty) {
            return 'Please enter your password';
          } else if (val.length < 6) {
            return 'Password must be at least 6 characters long';
          }
          return null;
        } else if (title == 'Confirm Password') {
          if (val == null || val.isEmpty) {
            return 'Please confirm your password';
          } else if (controller != null && val != controller!.text) {
            return 'Passwords do not match';
          }
          return null;
        } else {
          return null;
        }
      },
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintStyle: Theme.of(context).textTheme.bodyLarge,
        hintText: title,
        prefixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: Theme.of(context).iconTheme.size,
            color: Theme.of(context).iconTheme.color,
          ),
        ),

        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
