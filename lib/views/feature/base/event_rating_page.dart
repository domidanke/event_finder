import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/services/event_rating.service.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/custom_button.dart';
import 'package:event_finder/widgets/rating_bar.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/app_user.dart';
import '../../../services/firestore/user_doc.service.dart';
import '../../../services/popup.service.dart';
import '../../../services/storage/storage.service.dart';
import '../../../widgets/custom_icon_button.dart';

class EventRatingPage extends StatefulWidget {
  const EventRatingPage({super.key});

  @override
  State<EventRatingPage> createState() => _EventRatingPageState();
}

class _EventRatingPageState extends State<EventRatingPage> {
  final event = EventRatingService().selectedEventToRate!;
  Map<String, int> artistRatings = {}; // Keep track of ids and scores
  int eventRating = 0;
  bool isUploadingRatings = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Stack(
            children: [
              if (isUploadingRatings)
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Bewertung wird geschickt'),
                      SizedBox(
                        height: 16,
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              Opacity(
                opacity: isUploadingRatings ? 0.2 : 1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomIconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: event.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(event.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    RatingBar(
                        toRate: event.title,
                        onRated: (int rating) {
                          eventRating = rating;
                          setState(() {});
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    if (event.artists.isNotEmpty)
                      Expanded(
                        child: FirestoreListView<AppUser>(
                          emptyBuilder: (context) {
                            return const Center(
                              child: Text('Keine Artists'),
                            );
                          },
                          query: UserDocService().usersCollection.where(
                                FieldPath.documentId,
                                whereIn: event.artists,
                              ),
                          itemBuilder: (context, snapshot) {
                            final artist = snapshot.data();
                            if (!artistRatings.containsKey(artist.uid)) {
                              artistRatings[artist.uid] = 0;
                            }
                            Future<String> imageUrl =
                                StorageService().getUserImageUrl(artist.uid);
                            return Column(
                              children: [
                                FutureBuilder(
                                    future: imageUrl,
                                    builder: (context, snapshot) {
                                      artist.imageUrl = snapshot.data;
                                      if (snapshot.hasData) {
                                        if (snapshot.data == '') {
                                          return const CircleAvatar(
                                            radius: 40,
                                            backgroundImage: AssetImage(
                                                'assets/images/profile_placeholder.png'),
                                          );
                                        } else {
                                          return CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                              artist.imageUrl!,
                                            ),
                                          );
                                        }
                                      } else {
                                        return Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                                color: primaryWhite
                                                    .withOpacity(0.2),
                                                width: 0.2),
                                          ),
                                          child: const Center(
                                            child: SizedBox(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                        );
                                      }
                                    }),
                                const SizedBox(
                                  height: 8,
                                ),
                                RatingBar(
                                    toRate: artist.displayName,
                                    onRated: (int rating) {
                                      artistRatings[artist.uid] = rating;
                                      setState(() {});
                                    }),
                                const SizedBox(
                                  height: 50,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    SizedBox(
                        width: 200,
                        child: Opacity(
                          opacity: _isRatingDone() ? 1 : 0.4,
                          child: CustomButton(
                              onPressed: () async {
                                if (!_isRatingDone()) return;
                                setState(() {
                                  isUploadingRatings = true;
                                });
                                bool moreThanOneRating = false;
                                await EventDocService()
                                    .rateEvent(event, eventRating);
                                if (event.artists.isNotEmpty &&
                                    artistRatings.isNotEmpty) {
                                  await UserDocService()
                                      .rateArtists(artistRatings);
                                  moreThanOneRating = true;
                                }
                                await UserDocService()
                                    .finishRatingForUser(event.uid);
                                setState(() {
                                  isUploadingRatings = false;
                                });
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      PopupService().getCustomSnackBar(
                                          'Bewertung abgeschickt'));
                                  Navigator.pop(context);
                                }
                              },
                              buttonText: 'Jetzt abschicken'),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isRatingDone() {
    if (eventRating == 0) return false;
    for (var rating in artistRatings.values) {
      if (rating < 1) {
        return false;
      }
    }
    return true;
  }
}
