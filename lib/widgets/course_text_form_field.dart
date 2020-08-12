import 'package:flutter/material.dart';

class CourseTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function validator;

  CourseTextFormField({this.controller, this.hint, this.validator});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.description),
      title: TextFormField(
        controller: controller,
        decoration: InputDecoration(hintText: hint),
        validator: validator,
      ),
    );
  }
}
