import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/popup.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/shared/genre_picker.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_icon_button.dart';

class EditArtistGenresPage extends StatefulWidget {
  const EditArtistGenresPage({super.key});

  @override
  State<EditArtistGenresPage> createState() => _EditArtistGenresPageState();
}

class _EditArtistGenresPageState extends State<EditArtistGenresPage> {
  @override
  void initState() {
    fillGenres();
    super.initState();
  }

  void fillGenres() {
    StateService().resetSelectedGenres();
    final currentUser = StateService().currentUser!;
    for (var genre in currentUser.genres) {
      StateService().selectedGenres.add(genre);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 42),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 32,
                          )),
                      CustomIconButton(
                        icon: const Icon(Icons.save),
                        onPressed: () async {
                          await UserDocService().updateArtistGenres();
                          StateService().setCurrentUserGenres(
                              StateService().selectedGenres);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                PopupService()
                                    .getCustomSnackBar('Genres geändert'));
                            StateService().resetSelectedGenres();
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const GenrePicker(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
