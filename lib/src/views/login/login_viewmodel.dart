import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resultlr/resultlr.dart';
import 'package:wargame/src/services/war_api.dart';

import '../../../main.dart';
import '../../models/failure/failure.dart';
import '../../models/user/user.dart';
import '../../services/app_navigator.dart';
import '../../services/app_snackbars.dart';

class LoginViewModel with ChangeNotifier {
  late GetStorage _getStorage;
  late WarAPI _api;

  String _email = '';
  String get email => _email;

  String _name = '';
  String get name => _name;

  bool get isValidEmail => _email.contains('@');
  bool get isValidName => _name.length > 3;

  bool _isRegistering = false;
  bool get isRegistering => _isRegistering;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _disposed = false;

  Function() get onTap => isRegistering ? onRegistrar : onLogin;

  TextEditingController emailController = TextEditingController();

  update({required GetStorage getStorage, required WarAPI api}) {
    _getStorage = getStorage;
    _api = api;
  }

  checkLogin() async {
    String? getData = _getStorage.read('user');
    if (getData == null) return null;
    User userLoaded = User.fromJson(jsonDecode(getData));

    onChangedEmail(userLoaded.email);
    await onLogin();
  }

  onChangedEmail(String value) {
    _email = value;
    notifyListeners();
  }

  onChangedName(String value) {
    _name = value;
    notifyListeners();
  }

  changeIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  onLogin() async {
    if (!isValidEmail) {
      AppSnackBars.error(appStrings.string('invalidEmailMessage'));
      return;
    }
    changeIsLoading(true);
    ResultLR<Failure, User> result = await _api.login(_email.toLowerCase());
    if (result.isLeft()) {
      AppSnackBars.error(((result as Left).value as Failure).message);
      changeIsLoading(false);
      return;
    }

    _getStorage.write('user', jsonEncode((result as Right).value.toJson));
    AppNavigator.pushNameAndRemoveAll('/lobby');
  }

  onRegistrar() async {
    if (!isValidEmail) {
      AppSnackBars.error(appStrings.string('invalidEmailMessage'));
      return;
    }
    if (!isValidName) {
      AppSnackBars.error(appStrings.string('nameWith3Characters'));
      return;
    }
    if (isValidEmail && isValidName) {
      changeIsLoading(true);
      ResultLR<Failure, User> result =
          await _api.registerAccount(email: _email, name: _name);

      if (result.isLeft()) {
        changeIsLoading(false);
        AppSnackBars.error(((result as Left).value as Failure).message);
        return;
      }
      AppNavigator.pushNameAndRemoveAll('/lobby');
    }
  }

  changeIsRegistering() {
    _isRegistering = !_isRegistering;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
