import 'package:event_finder/models/enums.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class KKDrawer extends StatelessWidget {
  const KKDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UserAvatar(
                  size: 80,
                ),

                /// TODO: Make the text color global in themedata
                Text(
                  AuthService().getCurrentFirebaseUser()!.displayName ?? '-',
                  style: const TextStyle(fontSize: 18, color: primaryWhite),
                ),
                Text(
                  '${AuthService().getCurrentFirebaseUser()?.email}',
                  style: const TextStyle(fontSize: 12, color: primaryWhite),
                )
              ],
            ),
          ),
          if (AuthService().currentUser!.type == UserType.base)
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Meine Tickets'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          Opacity(
            opacity: AuthService().currentUser!.savedArtists.isEmpty ? 0.4 : 1,
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Meine Follows'),
              onTap: () {
                if (AuthService().currentUser!.savedArtists.isEmpty) return;
                Navigator.pop(context);
              },
            ),
          ),
          if (AuthService().currentUser!.type == UserType.base)
            Opacity(
              opacity: AuthService().currentUser!.savedEvents.isEmpty ? 0.4 : 1,
              child: ListTile(
                leading: const Icon(Icons.event_available),
                title: const Text('Gespeicherte Veranstaltungen'),
                onTap: () {
                  if (AuthService().currentUser!.savedEvents.isEmpty) return;
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
            leading: const Icon(Icons.account_circle_sharp),
            title: const Text('Mein Account'),
            onTap: () {
              Navigator.pushNamed(context, 'profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Support'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
