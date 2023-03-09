import 'package:event_finder/widgets/kk_button_async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/alert.service.dart';
import '../../services/auth.service.dart';
import '../../theme/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: primaryGradient,
      ),
      child: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text(
                  'Willkommen auf Event Finder, eine Plattform für Künstler, Veranstalter und Fans...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                ),
                Column(
                  children: [
                    TextFormField(
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
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
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
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
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
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
                          print('PW nicht gleich');
                          return;
                        }
                        try {
                          authService.registerLoading = true;
                          await authService
                              .signUp(
                                  emailController.text, passwordController.text)
                              .then((value) => {
                                    AuthService().sendEmailVerificationEmail(),
                                  });
                          if (mounted) Navigator.pushNamed(context, '/');
                        } on FirebaseAuthException catch (e) {
                          authService.registerLoading = false;
                          AlertService().showAlert(
                              'Registrierung fehlgeschlagen', e.code, context);
                        }
                      }
                    },
                    loading: authService.registerLoading,
                    buttonText: 'Registrieren'),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
