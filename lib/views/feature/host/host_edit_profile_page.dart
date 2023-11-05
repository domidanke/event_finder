import 'dart:io';

import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/image.service.dart';
import '../../../services/popup.service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/change_password_tile.dart';

class HostEditProfilePage extends StatefulWidget {
  const HostEditProfilePage({Key? key}) : super(key: key);

  @override
  State<HostEditProfilePage> createState() => _HostEditProfilePageState();
}

class _HostEditProfilePageState extends State<HostEditProfilePage> {
  @override
  Widget build(BuildContext context) {
    final bool isUploadingImage =
        Provider.of<StateService>(context).isUploadingImage;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Stack(
            children: [
              if (isUploadingImage)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Profilbild wird aktualisiert'),
                      SizedBox(
                        height: 16,
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              Opacity(
                opacity: isUploadingImage ? 0.2 : 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, top: 42),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 32,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Namen setzen'),
                            onTap: () {
                              Navigator.pushNamed(context, 'edit_display_name');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.location_on),
                            title: const Text('Location setzen'),
                            onTap: () {
                              Navigator.pushNamed(context, 'set_main_location');
                            },
                          ),
                          //const ChangePasswordTile(),
                          ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text('Profilbild setzen'),
                            onTap: () async {
                              final cropped = await ImageService()
                                  .selectImage(ratioX: 1, ratioY: 1);
                              if (cropped == null) return;
                              StateService().isUploadingImage = true;
                              await StorageService().saveProfileImageToStorage(
                                  File(cropped.path));
                              await StateService().refreshCurrentUserImageUrl();
                              StateService().currentUser!.imageUrl =
                                  await StorageService().getProfileImageUrl();
                              if (mounted) {
                                StateService().isUploadingImage = false;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    PopupService().getCustomSnackBar(
                                        'Profilbild geändert'));
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
