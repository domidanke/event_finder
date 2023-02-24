import 'package:event_finder/services/auth.service.dart';
import 'package:flutter/material.dart';

import '../services/alert.service.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({
    Key? key,
  }) : super(key: key);

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          onPressed: () async {
            setState(() {
              _isSigningIn = true;
            });
            try {
              await AuthService().signInWithGoogle();
              final user = AuthService().getCurrentFirebaseUser();
              if (user != null) {
                if (mounted) Navigator.pushNamed(context, 'home');
              }
            } catch (e) {
              debugPrint(e.toString());
              AlertService()
                  .showAlert('Login fehlgeschlagen', e.toString(), context);
            }

            setState(() {
              _isSigningIn = false;
            });
          },
          child: _isSigningIn
              ? const SizedBox(
                  height: 55,
                  width: 55,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Image(
                        image: AssetImage('assets/images/google_logo.png'),
                        height: 35.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Login mit Google',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      );
}
