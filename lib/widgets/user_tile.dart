import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

import 'genre_card.dart';

class UserTile extends StatefulWidget {
  const UserTile({Key? key, required this.user}) : super(key: key);
  final AppUser user;

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  late Future<String> _imageUrl;

  @override
  void initState() {
    _imageUrl = StorageService().getUserImageUrl(widget.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.user.type == UserType.artist) {
          StateService().lastSelectedArtist = widget.user;
          Navigator.pushNamed(context, 'artist_page');
        } else {
          StateService().lastSelectedHost = widget.user;
          Navigator.pushNamed(context, 'host_page');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          children: [
            Card(
              color: primaryBackgroundColor.withOpacity(0.5),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: 4),
                leading: FutureBuilder(
                    future: _imageUrl,
                    builder: (context, snapshot) {
                      widget.user.imageUrl = snapshot.data;
                      if (snapshot.hasData) {
                        if (snapshot.data == '') {
                          return const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                                'assets/images/profile_placeholder.png'),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              widget.user.imageUrl!,
                            ),
                          );
                        }
                      } else {
                        return Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: primaryWhite.withOpacity(0.2),
                                width: 0.2),
                          ),
                          child: const Center(
                            child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator()),
                          ),
                        );
                      }
                    }),
                title: Text(widget.user.displayName),
                subtitle: widget.user.type == UserType.artist
                    ? Row(children: [
                        ...widget.user.genres
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Opacity(opacity: 0.5, child: Text(e)),
                                ))
                            .take(3)
                            .toList(),
                        if (widget.user.genres.length > 3)
                          GenreCard(
                              text:
                                  '+${(widget.user.genres.length - 3).toString()}')
                      ])
                    : Opacity(
                        opacity: 0.5,
                        child: Text('${widget.user.follower.length} Follower')),
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
