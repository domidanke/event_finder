import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map<String, String> kAlertMap = const {
  'invalid-email': 'Bitte geben Sie eine gültige Email an.',
  'user-not-found': 'Sorry, we can\'t find an account with this email address.',
  'wrong-password':
      'Email oder Passwort sind falsch. Bitte versuchen Sie es erneut.',
  'weak-password': 'Das Passwort muss mindestens 6 Charaktere haben.',
  'email-already-in-use': 'Die Email wird bereits genutzt.',
  'operation-not-allowed': 'Something went wrong on the Server',
  'internal-error': 'Etwas ist schiefgelaufen'
};

class AlertService {
  void showAlert(String title, String messageCode, BuildContext context) {
    debugPrint(messageCode);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(kAlertMap[messageCode] ?? 'Fehlercode unbekannt')),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(kAlertMap[messageCode] ?? 'Fehlercode unbekannt'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
      },
    );
  }
}
