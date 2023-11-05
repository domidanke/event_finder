import 'package:flutter/material.dart';

import '../services/auth.service.dart';
import '../theme/theme.dart';
import 'custom_button.dart';

class ChangePasswordTile extends StatefulWidget {
  const ChangePasswordTile({super.key});

  @override
  State<ChangePasswordTile> createState() => _ChangePasswordTileState();
}

class _ChangePasswordTileState extends State<ChangePasswordTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.password),
      title: const Text('Passwort ändern'),
      onTap: () {
        _showConfirmSheet();
      },
    );
  }

  void _showConfirmSheet() async {
    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    buttonText: 'Abbrechen'),
                CustomButton(
                    onPressed: () {
                      AuthService().sendPasswordResetEmail(
                          AuthService().getCurrentFirebaseUser()!.email!);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email gesendet')));
                      Navigator.pop(context);
                    },
                    buttonText: 'Anwenden')
              ],
            )
          ],
        ),
      ),
    );
  }
}
