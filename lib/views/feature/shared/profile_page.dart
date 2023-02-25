import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ProfileScreen(
          actions: [
            SignedOutAction((context) {
              Navigator.pushNamed(context, 'login');
            }),
          ],
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('Hier kann was stehen'),
                Text('Events'),
                Text('2'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
