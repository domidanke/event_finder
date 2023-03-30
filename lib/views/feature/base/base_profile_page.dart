import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/views/feature/shared/popup_menu.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../models/enums.dart';

class BaseProfilePage extends StatefulWidget {
  const BaseProfilePage({Key? key}) : super(key: key);

  @override
  State<BaseProfilePage> createState() => _BaseProfilePageState();
}

class _BaseProfilePageState extends State<BaseProfilePage> {
  late Future<String> _imageUrl;

  @override
  void initState() {
    _imageUrl = StorageService().getProfileImageUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppUser currentUser = Provider.of<StateService>(context).currentUser!;
    return RefreshIndicator(
      onRefresh: () async {
        StateService().currentUser =
            await UserDocService().getCurrentUserData();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListView(
              children: [
                currentUser.imageUrl != null
                    ? CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(currentUser.imageUrl!))
                    : FutureBuilder(
                        future: _imageUrl,
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
                          currentUser.imageUrl = snapshot.data;
                          if (snapshot.hasData) {
                            return CircleAvatar(
                              radius: 100,
                              backgroundImage: snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? null
                                  : currentUser.imageUrl != null
                                      ? NetworkImage(currentUser.imageUrl!)
                                      : Image.asset(
                                              'assets/images/profile_placeholder.png')
                                          .image,
                              child: snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const CircularProgressIndicator()
                                  : null,
                            );
                          } else {
                            return const SizedBox(
                                height: 100,
                                width: 100,
                                child: CircularProgressIndicator());
                          }
                        }),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                        '${currentUser.displayName} (${currentUser.type.name.toUpperCase()})'),
                    const Spacer(),
                    KKPopupMenu(
                      onItemSelect: (int index) async {
                        if (index == 2) {
                          await AuthService().signOut().then((value) => {
                                StateService().resetCurrentUserSilent(),
                                Navigator.pushNamedAndRemoveUntil(context, '/',
                                    (Route<dynamic> route) => false),
                              });
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                if (currentUser.type == UserType.base)
                  Opacity(
                    opacity: currentUser.allTickets.isEmpty ? 0.4 : 1,
                    child: ListTile(
                      leading: const Icon(Icons.receipt),
                      title: const Text('Meine Tickets'),
                      onTap: () {
                        if (currentUser.allTickets.isEmpty) return;
                        Navigator.pushNamed(context, 'tickets');
                      },
                    ),
                  ),
                if (currentUser.type != UserType.artist)
                  Opacity(
                    opacity: currentUser.savedArtists.isEmpty ? 0.4 : 1,
                    child: ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('Meine Artists'),
                      onTap: () {
                        if (currentUser.savedArtists.isEmpty) {
                          return;
                        }
                        Navigator.pushNamed(context, 'saved_artists');
                      },
                    ),
                  ),
                if (currentUser.type != UserType.host)
                  Opacity(
                    opacity: currentUser.savedHosts.isEmpty ? 0.4 : 1,
                    child: ListTile(
                      leading: const Icon(Icons.house),
                      title: const Text('Meine Hosts'),
                      onTap: () {
                        if (currentUser.savedHosts.isEmpty) {
                          return;
                        }
                        Navigator.pushNamed(context, 'saved_hosts');
                      },
                    ),
                  ),
                if (currentUser.type == UserType.base)
                  Opacity(
                    opacity: currentUser.savedEvents.isEmpty ? 0.4 : 1,
                    child: ListTile(
                      leading: const Icon(Icons.event_available),
                      title: const Text('Gespeicherte Veranstaltungen'),
                      onTap: () {
                        if (currentUser.savedEvents.isEmpty) {
                          return;
                        }
                        Navigator.pushNamed(context, 'saved_events');
                      },
                    ),
                  ),
                if (currentUser.type == UserType.host &&
                    currentUser.mainLocationCoordinates.latitude == 0 &&
                    currentUser.mainLocationCoordinates.longitude == 0)
                  KKButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'set_main_location');
                      },
                      buttonText: 'Setze deine Main Location'),
              ],
            ),
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
              setState(() {
                _imageUrl = StorageService().getProfileImageUrl();
              });
            },
          ),
          const Text('Profilbild hinzufuegen')
        ],
      ),
    );
  }
}
