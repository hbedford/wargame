import 'package:flutter/material.dart';

import '../app.dart';
import '../widgets/snackbars/snackbar_error.dart';

class AppSnackBars {
  AppSnackBars._();

  static error(String title) =>
      ScaffoldMessenger.of(navigationApp.currentContext!)
          .showSnackBar(SnackbarError(text: title));
}
