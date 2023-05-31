import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const CustomIconButton(),
                    const Spacer(),
                    CustomIconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () async {
                        await UserDocService().updateArtistGenres();
                        StateService().setCurrentUserGenres(
                            StateService().selectedGenres);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Genres geändert')),
                          );
                          StateService().resetSelectedGenres();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              const GenrePicker(),
            ],
          ),
        ),
      ),
    );
  }
}
