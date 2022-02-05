import 'dart:convert';

import 'package:flutter/services.dart';
import 'dart:io';

class AppStrings {
  AppStrings();
  static String get locale => Platform.localeName;
  Map<String, dynamic>? _localizedStrings;
  Future<void> load() async {
    String jsonString = await rootBundle.loadString('assets/i18n/$locale.json');
    if (jsonString.isEmpty) {
      jsonString = await rootBundle.loadString('assets/i18n/en_US.json');
    }
    _localizedStrings = jsonDecode(jsonString);

    return;
  }

  String string(String key) =>
      _localizedStrings![key] ?? 'String não registrada';
}
