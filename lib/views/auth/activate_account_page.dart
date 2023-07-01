import 'package:event_finder/widgets/google_activate_button.dart';
import 'package:event_finder/widgets/kk_button_async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/alert.service.dart';
import '../../services/auth.service.dart';

class ActivateAccountPage extends StatefulWidget {
  const ActivateAccountPage({Key? key}) : super(key: key);

  @override
  State<ActivateAccountPage> createState() => _ActivateAccountPageState();
}

class _ActivateAccountPageState extends State<ActivateAccountPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    'Willkommen auf Nocstar, eine Plattform für Künstler, Veranstalter und Fans...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(
                    height: 18,
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
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte geben Sie Ihr Passwort erneut ein';
                          } else if (value != passwordController.text) {
                            return 'Passwort ist nicht gleich';
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Passwort wiederholen',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  KKButtonAsync(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            return;
                          }
                          try {
                            authService.registerLoading = true;
                            await authService.activateAccountWithEmail(
                                emailController.text, passwordController.text);
                            AuthService().sendEmailVerificationEmail();
                            authService.registerLoading = false;
                            if (mounted) Navigator.pushNamed(context, '/');
                          } on FirebaseAuthException catch (e) {
                            authService.registerLoading = false;
                            AlertService().showAlert(
                                'Registrierung fehlgeschlagen',
                                e.code,
                                context);
                          }
                        }
                      },
                      loading: authService.registerLoading,
                      buttonText: 'Registrieren'),
                  const SizedBox(
                    height: 30,
                  ),
                  const GoogleActivateButton(),
                ],
              ),
            ),
          ),
        ));
  }
}
