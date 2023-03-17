import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/enums.dart';

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
              Text(AuthService().getCurrentFirebaseUser()!.displayName ?? '-'),
              Text(AuthService().getCurrentFirebaseUser()!.email!),
              const SizedBox(
                height: 10,
              ),
              Text(
                  '(DEV) Account Type: ${AuthService().currentUser!.type.name.toUpperCase()}'),
              const SizedBox(
                height: 50,
              ),
              if (AuthService().currentUser!.type == UserType.base)
                ListTile(
                  leading: const Icon(Icons.receipt),
                  title: const Text('Meine Tickets'),
                  onTap: () {},
                ),
              Opacity(
                opacity:
                    AuthService().currentUser!.savedArtists.isEmpty ? 0.4 : 1,
                child: ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Meine Follows'),
                  onTap: () {
                    if (AuthService().currentUser!.savedArtists.isEmpty) return;
                  },
                ),
              ),
              if (AuthService().currentUser!.type == UserType.base)
                Opacity(
                  opacity:
                      AuthService().currentUser!.savedEvents.isEmpty ? 0.4 : 1,
                  child: ListTile(
                    leading: const Icon(Icons.event_available),
                    title: const Text('Gespeicherte Veranstaltungen'),
                    onTap: () {
                      if (AuthService().currentUser!.savedEvents.isEmpty) {
                        return;
                      }
                      Navigator.pushNamed(context, 'saved_events');
                    },
                  ),
                ),
              if (AuthService().currentUser!.type == UserType.host)
                ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Meine Veranstaltungen'),
                  onTap: () {
                    Navigator.pushNamed(context, 'created_events');
                  },
                ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Support'),
                onTap: () {},
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
