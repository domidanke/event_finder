import 'package:event_finder/services/alert.service.dart';
import 'package:event_finder/widgets/kk_button_async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth.service.dart';
import '../../widgets/google_sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return WillPopScope(
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text(
                      'Event Finder',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte geben Sie eine Email ein';
                            }
                            return null;
                          },
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte geben Sie ein Passwort ein';
                            }
                            return null;
                          },
                          obscureText: true,
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Passwort',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            ///TODO: forgot password screen
                          },
                          child: const Text(
                            'Passwort vergessen',
                          ),
                        ),
                        KKButtonAsync(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                try {
                                  authService.loginLoading = true;
                                  await authService
                                      .signInNative(emailController.text,
                                          passwordController.text)
                                      .then((value) => {
                                            authService.loginLoading = false,
                                            Navigator.pushNamed(context, '/'),
                                          });
                                } on FirebaseAuthException catch (e) {
                                  authService.loginLoading = false;
                                  AlertService().showAlert(
                                      'Login fehlgeschlagen', e.code, context);
                                }
                              }
                            },
                            loading: authService.loginLoading,
                            buttonText: 'Login'),
                        const SizedBox(
                          height: 20,
                        ),
                        const GoogleSignInButton(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Noch keinen Account?'),
                        Row(
                          children: [
                            TextButton(
                              child: const Text(
                                'Hier',
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, 'register');
                              },
                            ),
                            const Text('registrieren')
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
