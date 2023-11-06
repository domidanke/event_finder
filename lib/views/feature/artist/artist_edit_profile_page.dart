import 'dart:io';

import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/views/feature/artist/edit_artist_genres_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/image.service.dart';
import '../../../theme/theme.dart';

class ArtistEditProfilePage extends StatefulWidget {
  const ArtistEditProfilePage({Key? key}) : super(key: key);

  @override
  State<ArtistEditProfilePage> createState() => _ArtistEditProfilePageState();
}

class _ArtistEditProfilePageState extends State<ArtistEditProfilePage> {
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
                      Expanded(
                        child: ListView(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text('Anderer Name'),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, 'edit_display_name');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.queue_music_outlined),
                              title: const Text('Andere Genres'),
                              onTap: () {
                                showModalBottomSheet<String>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) =>
                                      const EditArtistGenresPage(),
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text('Anderes Profilbild'),
                              onTap: () async {
                                final cropped =
                                    await ImageService().selectImage();
                                if (cropped == null) return;
                                StateService().isUploadingImage = true;
                                await StorageService()
                                    .saveProfileImageToStorage(
                                        File(cropped.path));
                                await StateService()
                                    .refreshCurrentUserImageUrl();
                                StateService().currentUser!.imageUrl =
                                    await StorageService().getProfileImageUrl();
                                if (mounted) {
                                  StateService().isUploadingImage = false;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Profilbild geändert')),
                                  );
                                }
                              },
                            ),
                            //const ChangePasswordTile(),
                          ],
                        ),
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
