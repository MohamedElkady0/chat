import 'package:flutter/material.dart';

class InputFieldAuth extends StatelessWidget {
  const InputFieldAuth({
    super.key,
    required this.title,
    required this.icon,
    this.validator,
    this.onSaved,
    this.keyboardType,
    required this.obscureText,
    this.controller,
  });

  final String title;
  final IconData icon;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }
}
