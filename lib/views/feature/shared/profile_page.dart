import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/widgets/kk_button.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const UserAvatar(),
              const SizedBox(
                height: 50,
              ),
              Text(AuthService().getCurrentFirebaseUser()!.displayName ?? '-'),
              const SizedBox(
                height: 20,
              ),
              Text(AuthService().getCurrentFirebaseUser()!.email!),
              const SizedBox(
                height: 20,
              ),
              Text('Account Type: ${AuthService().currentUser!.type.name}'),
              const SizedBox(
                height: 50,
              ),
              KKButton(
                  onPressed: () async {
                    await AuthService().signOut().then((value) => {
                          Navigator.pushNamedAndRemoveUntil(context, 'login',
                              (Route<dynamic> route) => false),
                        });
                  },
                  buttonText: 'Log Out')
            ],
          ),
        ),
      ),
    );
  }
}
