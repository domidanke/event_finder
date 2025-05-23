import 'package:event_finder/services/alert.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/custom_button_async.dart';
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(gradient: primaryGradient),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text(
                      'Nocstar',
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
                            _showForgotPasswordModal(context);
                          },
                          child: const Text(
                            'Passwort vergessen',
                            style: TextStyle(
                                color: primaryWhite,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        CustomButtonAsync(
                            onPressed: () async {
                              if (authService.loginLoading) return;
                              if (formKey.currentState!.validate()) {
                                try {
                                  FocusScope.of(context).unfocus();
                                  authService.loginLoading = true;
                                  await authService
                                      .signInNative(emailController.text,
                                          passwordController.text)
                                      .then((value) => {
                                            authService.loginLoading = false,
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/',
                                                (Route<dynamic> route) =>
                                                    false),
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
                    TextButton(
                      child: const Text(
                        'Weiter als Gast',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: primaryWhite),
                      ),
                      onPressed: () async {
                        try {
                          await AuthService().signInAsGuest();
                          if (mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (Route<dynamic> route) => false);
                          }
                        } on FirebaseAuthException catch (e) {
                          AlertService().showAlert(
                              'Login fehlgeschlagen 1/2', e.code, context);
                        } on Exception catch (e) {
                          AlertService().showAlert(
                              'Login fehlgeschlagen 2/2', '', context);
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Noch keinen Account?'),
                        Row(
                          children: [
                            TextButton(
                              child: const Text(
                                'registrieren',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: primaryWhite),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, 'register');
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _showForgotPasswordModal(BuildContext context) {
    final passwordResetFormKey = GlobalKey<FormState>();
    TextEditingController passwordResetEmailController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email angeben'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                key: passwordResetFormKey,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte geben Sie eine Email ein';
                    }
                    return null;
                  },
                  controller: passwordResetEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Senden'),
              onPressed: () async {
                if (passwordResetFormKey.currentState!.validate()) {
                  String email = passwordResetEmailController.text;
                  try {
                    await AuthService().sendPasswordResetEmail(email);
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email gesendet')));
                    }
                  } on FirebaseAuthException catch (e) {
                    if (mounted) {
                      AlertService()
                          .showAlert('Fehlgeschlagen', e.code, context);
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
