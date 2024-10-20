import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  final String hintText;
  final double height;
  final RegExp validationRegEx;
  final bool obscureText;
  final void Function(String?) onSaved;

    const CustomForm({
    super.key,
    required this.hintText,
    required this.height, 
    required this.validationRegEx,
    required this.onSaved,
    this.obscureText = false,
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        onSaved: onSaved,
        obscureText: obscureText,
        validator: (value){
          if(value!= null && validationRegEx.hasMatch(value)){
            return null;
          }
          return "enter a valid ${hintText.toLowerCase()}";
        },
        decoration: InputDecoration(
          hintText: hintText ,
          border:const OutlineInputBorder(),
        ),
      ),
    );
  }
}