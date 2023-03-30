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

class HostProfilePage extends StatefulWidget {
  const HostProfilePage({Key? key}) : super(key: key);

  @override
  State<HostProfilePage> createState() => _HostProfilePageState();
}

class _HostProfilePageState extends State<HostProfilePage> {
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
                if (currentUser.mainLocation.geoHash.isEmpty)
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
