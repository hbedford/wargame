import 'package:flutter/material.dart';

class SnackbarError extends SnackBar {
  final String text;
  SnackbarError({Key? key, required this.text})
      : super(key: key, content: Text(text));
}
