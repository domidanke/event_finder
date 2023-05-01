import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

class ArtistTile extends StatefulWidget {
  const ArtistTile({Key? key, required this.artist}) : super(key: key);
  final AppUser artist;

  @override
  State<ArtistTile> createState() => _ArtistTileState();
}

class _ArtistTileState extends State<ArtistTile> {
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: primaryBackgroundColor.withOpacity(0.7),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: 4),
                leading: FutureBuilder(
                    future: _imageUrl,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundImage: Image.asset(
                                  'assets/images/profile_placeholder.png')
                              .image,
                        );
                      }
                      widget.artist.imageUrl = snapshot.data;
                      return CircleAvatar(
                        radius: 30,
                        backgroundImage: snapshot.connectionState ==
                                ConnectionState.waiting
                            ? null
                            : widget.artist.imageUrl != null
                                ? NetworkImage(widget.artist.imageUrl!)
                                : Image.asset(
                                        'assets/images/profile_placeholder.png')
                                    .image,
                        child:
                            snapshot.connectionState == ConnectionState.waiting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(),
                                  )
                                : null,
                      );
                    }),
                title: Text(widget.artist.displayName),
                subtitle: Row(
                  children: widget.artist.genres
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Opacity(opacity: 0.5, child: Text(e)),
                          ))
                      .toList(),
                ),
                trailing: Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
