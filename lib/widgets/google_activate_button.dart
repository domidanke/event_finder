import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:flutter/material.dart';

import '../services/alert.service.dart';

class GoogleActivateButton extends StatefulWidget {
  const GoogleActivateButton({
    Key? key,
  }) : super(key: key);

  @override
  State<GoogleActivateButton> createState() => _GoogleActivateButtonState();
}

class _GoogleActivateButtonState extends State<GoogleActivateButton> {
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
              await AuthService().activateAccountWithGoogle();
              await UserDocService().upgradeUserDocument();
              if (mounted) Navigator.pushNamed(context, '/');
            } catch (e) {
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
              : const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Image(
                    image: AssetImage('assets/images/google_logo.png'),
                    height: 35.0,
                  ),
                ),
        ),
      );
}
