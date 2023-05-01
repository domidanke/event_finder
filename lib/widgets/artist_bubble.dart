import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

class ArtistBubble extends StatefulWidget {
  const ArtistBubble({Key? key, required this.artist}) : super(key: key);
  final AppUser artist;

  @override
  State<ArtistBubble> createState() => _ArtistBubbleState();
}

class _ArtistBubbleState extends State<ArtistBubble> {
  late Future<String> _imageUrl;

  @override
  void initState() {
    _imageUrl = StorageService().getUserImageUrl(widget.artist.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        StateService().lastSelectedArtist = widget.artist;
        Navigator.pushNamed(context, 'artist_page');
      },
      child: FittedBox(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Card(
              color: primaryBackgroundColor.withOpacity(0.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FutureBuilder(
                      future: _imageUrl,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return CircleAvatar(
                            radius: 60,
                            backgroundImage: Image.asset(
                                    'assets/images/profile_placeholder.png')
                                .image,
                          );
                        }
                        widget.artist.imageUrl = snapshot.data;
                        return CircleAvatar(
                          radius: 60,
                          backgroundImage: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? null
                              : widget.artist.imageUrl != null
                                  ? NetworkImage(widget.artist.imageUrl!)
                                  : Image.asset(
                                          'assets/images/profile_placeholder.png')
                                      .image,
                          child: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(),
                                )
                              : null,
                        );
                      }),
                  Text(widget.artist.displayName),
                  Text('Follower: ${widget.artist.follower.length}'),
                ],
              )),
        ),
      ),
    );
  }
}
