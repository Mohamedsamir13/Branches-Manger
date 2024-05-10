import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool readOnly; // New property
  final double? width;
  final double? height;
  final String? Function(String?)? validator; // New property for validator


  CustomTextField({
    required this.label,
    required this.controller,
    this.onChanged,
    this.readOnly = false, // Default value for readOnly
    this.width,
    this.height, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: width,
      height: height,
      child: Expanded(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          controller: controller,
          onChanged: onChanged,
          readOnly: readOnly,
        ),
      ),
    );
  }
}
