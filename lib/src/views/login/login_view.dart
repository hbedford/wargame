import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:wargame/main.dart';
import 'package:wargame/src/services/war_api.dart';

import 'login_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProxyProvider2<GetStorage, WarAPI, LoginViewModel>(
        create: (_) => LoginViewModel(),
        update: (_, getStorage, api, viewModel) =>
            viewModel!..update(getStorage: getStorage, api: api),
        child: Consumer<LoginViewModel>(
          builder: (_, provider, __) => Padding(
            padding: const EdgeInsets.all(24.0),
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appStrings.string(provider.isRegistering
                            ? 'titleRegister'
                            : 'titleLogin'),
                        style: const TextStyle(color: Colors.white),
                      ),
                      AnimatedOpacity(
                        opacity: provider.isRegistering ? 1 : 0,
                        duration: const Duration(seconds: 1),
                        child: SizedBox(
                          width: 400,
                          child: TextField(
                            decoration: InputDecoration(
                                labelText: appStrings.string('name')),
                            enabled: provider.isRegistering,
                            onChanged: provider.onChangedName,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 400,
                        child: TextField(
                          controller: provider.emailController,
                          decoration: InputDecoration(
                              labelText: appStrings.string('inputEmail')),
                          onChanged: provider.onChangedEmail,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoButton.filled(
                            child: Text(
                              appStrings.string(
                                  provider.isRegistering ? 'signIn' : 'logIn'),
                            ),
                            onPressed: provider.onTap,
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: provider.changeIsRegistering,
                            child: Text(
                              appStrings.string(
                                  provider.isRegistering ? 'logIn' : 'signIn'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
