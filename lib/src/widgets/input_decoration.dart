import 'package:flutter/material.dart';


InputDecoration buildInputDecoration({String? label, String? hintText}) {
  return InputDecoration(
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xff69639F), width: 2.0)),
      labelText: label,
      hintText: hintText);
}
