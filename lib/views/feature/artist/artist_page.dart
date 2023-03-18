import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/widgets/kk_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({Key? key}) : super(key: key);

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  @override
  Widget build(BuildContext context) {
    final AppUser artist =
        Provider.of<StateService>(context).lastSelectedArtist!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: artist.imageUrl != null
                    ? NetworkImage(artist.imageUrl!)
                    : Image.asset('assets/images/profile_placeholder.png')
                        .image,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(artist.displayName),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KKIcon(
                    icon: const Icon(Icons.facebook),
                    onPressed: () async {
                      final url = Uri.parse(artist.externalLinks.facebook);
                      await launchUrl(url);
                    },
                  ),
                  KKIcon(
                    icon: const Icon(Icons.whatshot),
                    onPressed: () async {
                      final url = Uri.parse(artist.externalLinks.soundCloud);
                      await launchUrl(url);
                    },
                  ),
                  KKIcon(
                    icon: const Icon(Icons.camera_alt_outlined),
                    onPressed: () async {
                      final url = Uri.parse(artist.externalLinks.instagram);
                      await launchUrl(url);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
