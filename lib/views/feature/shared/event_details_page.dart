import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/date.service.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/location.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/custom_button.dart';
import 'package:event_finder/widgets/custom_icon_button.dart';
import 'package:event_finder/widgets/rating_indicator.dart';
import 'package:event_finder/widgets/user_tile.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/app_user.dart';
import '../../../widgets/genre_card.dart';
import '../../../widgets/save_event_button.dart';
import '../host/edit_event_details.dart';
import 'location_snippet.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late Future<List<Placemark>> _placeMarks;

  @override
  void initState() {
    final event = StateService().lastSelectedEvent!;
    _placeMarks = placemarkFromCoordinates(
        event.location.geoPoint.latitude, event.location.geoPoint.longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Event event = Provider.of<StateService>(context).lastSelectedEvent!;
    final currentUser = StateService().currentUser!;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
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
                    if (event.startDate.isBefore(DateTime.now()))
                      Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: RatingIndicator(
                            ratingData: event.ratingData,
                            isSmall: false,
                          )),
                    if (currentUser.type == UserType.base)
                      SaveEventButton(
                        event: event,
                      ),
                    if (currentUser.type == UserType.host &&
                        currentUser.uid == event.creatorId &&
                        event.startDate.isAfter(DateTime.now()))
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: IconButton(
                            color: secondaryColor,
                            onPressed: () async {
                              Navigator.pushNamed(context, 'scan_qr_code');
                            },
                            icon: const Icon(
                              Icons.qr_code,
                              size: 32,
                            )),
                      )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: AspectRatio(
                        aspectRatio: 5 / 3,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: event.imageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                      event.imageUrl!,
                                    ),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Text(
                        event.title,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    if (currentUser.type == UserType.base)
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Text(
                              'Von ',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: primaryWhite.withOpacity(0.5)),
                            ),
                            GestureDetector(
                              onTap: () async {
                                StateService().lastSelectedHost =
                                    await UserDocService()
                                        .getUserData(event.creatorId);
                                StateService().lastSelectedHost!.imageUrl =
                                    await StorageService()
                                        .getUserImageUrl(event.creatorId);
                                if (mounted) {
                                  Navigator.pushNamed(context, 'host_page');
                                }
                              },
                              child: Text(
                                event.creatorName,
                                style: const TextStyle(
                                    fontSize: 16, color: secondaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              const CustomIconButton(
                                size: 0,
                                icon: Icon(
                                  Icons.date_range,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateService().getDateText(event.startDate),
                                    style:
                                        const TextStyle(color: secondaryColor),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    DateService().getTimeText(
                                        event.startDate, event.endDate),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: const Row(
                            children: [
                              CustomIconButton(
                                size: 0,
                                icon: Icon(
                                  Icons.music_note,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Wrap(
                            children: [
                              ...event.genres
                                  .map(
                                    (genre) => GenreCard(text: genre),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              const CustomIconButton(
                                  size: 0,
                                  icon: Icon(
                                    Icons.location_pin,
                                    size: 16,
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              FutureBuilder(
                                future: _placeMarks,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Placemark>> snapshot) {
                                  if (snapshot.hasData) {
                                    final placeMark = snapshot.data![0];
                                    return GestureDetector(
                                      onTap: () async {
                                        await LocationService()
                                            .openEventInMap(event);
                                      },
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          '${placeMark.street} ${placeMark.postalCode} ${placeMark.locality}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (event.artists.isNotEmpty &&
                        currentUser.type != UserType.guest)
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                const CustomIconButton(
                                    size: 0,
                                    icon: Icon(
                                      Icons.people,
                                      size: 16,
                                    )),
                                const SizedBox(
                                  width: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('Künstler'),
                                    IconButton(
                                        onPressed: () {
                                          _showArtistsModal();
                                        },
                                        icon: const Icon(
                                          Icons.open_in_new,
                                          color: secondaryColor,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: const Text(
                        'Beschreibung',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: SingleChildScrollView(
                            child: Text(
                          event.details,
                          style: const TextStyle(height: 1.5),
                        ))),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: const Text(
                        'Location',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: 250,
                      child: LocationSnippet(
                          coordinates: LatLng(event.location.geoPoint.latitude,
                              event.location.geoPoint.longitude)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (event.creatorId == currentUser.uid)
                      Center(
                          child: Text(
                              'Verkaufte Tickets: ${event.soldTickets.length} / ${event.maxTickets}')),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              if (currentUser.type == UserType.base &&
                  event.startDate.isAfter(DateTime.now()))
                StreamBuilder(
                  stream: EventDocService()
                      .eventsCollection
                      .doc(event.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      final event = snapshot.data!.data()!;
                      if (event.soldTickets.length < event.maxTickets) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          width: 180,
                          child: CustomButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'buy_tickets');
                            },
                            buttonText: 'Tickets hier kaufen',
                          ),
                        );
                      } else {
                        return Opacity(
                          opacity: 0.4,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            width: 180,
                            child: CustomButton(
                              onPressed: () {},
                              buttonText: 'Ausverkauft',
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              if (currentUser.type == UserType.guest)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      const Text('Du willst Tickets kaufen?'),
                      const SizedBox(
                        height: 4,
                      ),
                      const Text('Dann registriere Dich jetzt'),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 180,
                        child: CustomButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'activate_account');
                          },
                          buttonText: 'Aktiviere Account',
                        ),
                      ),
                    ],
                  ),
                ),
              if (event.creatorId == currentUser.uid &&
                  event.startDate.isAfter(DateTime.now()))
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  width: 220,
                  child: CustomButton(
                    onPressed: () {
                      showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) =>
                            const EditEventDetails(),
                      );
                    },
                    buttonText: 'Beschreibung bearbeiten',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showArtistsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(gradient: primaryGradient),
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
            Expanded(
              child: FirestoreListView<AppUser>(
                emptyBuilder: (context) {
                  return const Center(
                    child: Text('Keine Artists'),
                  );
                },
                query: UserDocService().usersCollection.where(
                      FieldPath.documentId,
                      whereIn: StateService().lastSelectedEvent!.artists,
                    ),
                itemBuilder: (context, snapshot) {
                  return UserTile(user: snapshot.data());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
