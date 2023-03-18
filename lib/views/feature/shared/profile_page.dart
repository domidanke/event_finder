import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/storage.service.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
              AuthService().currentUser!.imageUrl != null
                  ? CircleAvatar(
                      radius: 100,
                      backgroundImage:
                          NetworkImage(AuthService().currentUser!.imageUrl!))
                  : FutureBuilder(
                      future: StorageService().getProfileImageUrl(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          final e = snapshot.error as FirebaseException;
                          if (e.code == 'object-not-found') {
                            return _getUploadProfileWidget();
                          } else {
                            return CircleAvatar(
                              radius: 100,
                              backgroundImage: Image.asset(
                                      'assets/images/profile_placeholder.png')
                                  .image,
                            );
                          }
                        }
                        AuthService().currentUser!.imageUrl = snapshot.data;
                        return CircleAvatar(
                          radius: 100,
                          backgroundImage: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? null
                              : AuthService().currentUser!.imageUrl != null
                                  ? NetworkImage(
                                      AuthService().currentUser!.imageUrl!)
                                  : Image.asset(
                                          'assets/images/profile_placeholder.png')
                                      .image,
                          child: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const CircularProgressIndicator()
                              : null,
                        );
                      }),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Text(AuthService().currentUser!.displayName),
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
                    if (AuthService().currentUser!.savedArtists.isEmpty) {
                      return;
                    }
                    Navigator.pushNamed(context, 'saved_artists');
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

  Widget _getUploadProfileWidget() {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 50,
            ),
            onPressed: () async {
              final XFile? image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (image == null) return;
              await StorageService()
                  .saveProfileImageToStorage(File(image.path));
              setState(() {});
            },
          ),
          const Text('Profilbild hinzufuegen')
        ],
      ),
    );
  }
}
