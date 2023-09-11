import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/location.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/custom_button.dart';
import 'package:event_finder/widgets/custom_icon_button.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

import '../../../models/app_user.dart';
import '../../../models/consts.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late Future<String> _imageUrl;
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
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
                decoration: BoxDecoration(
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
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(event.title,
                                style: const TextStyle(
                                    fontSize: 24, color: secondaryColor)),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: const BorderSide(
                                    color: secondaryColor, width: 1),
                              ),
                              child: SizedBox(
                                  width: 50,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      '${event.ticketPrice} €',
                                      style: const TextStyle(
                                          color: secondaryColor),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          const CustomIconButton(
                            icon: Icon(Icons.access_time),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.startDate.toString().substring(0, 10)),
                              Text(_getTimeText(event))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (currentUser.type == UserType.host &&
                        event.startDate.isAfter(DateTime.now()))
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: IconButton(
                            color: secondaryColor,
                            onPressed: () async {
                              Navigator.pushNamed(context, 'scan_qr_code');
                            },
                            icon: const Icon(Icons.qr_code)),
                      )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const CustomIconButton(
                            icon: Icon(Icons.music_note),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ..._getGenreWidgets(),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (event.artists.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: IconButton(
                            onPressed: () {
                              _showArtistsModal();
                            },
                            icon: const Icon(
                              Icons.people,
                              color: secondaryColor,
                            )),
                      ),
                  ],
                ),
                if (currentUser.type != UserType.host)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const CustomIconButton(icon: Icon(Icons.house)),
                        const SizedBox(
                          width: 12,
                        ),
                        TextButton(
                          onPressed: _navigateToHost,
                          child: Text(event.creatorName),
                        ),
                      ],
                    ),
                  ),
                if (currentUser.type != UserType.host)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const CustomIconButton(icon: Icon(Icons.location_city)),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Container(
                            alignment: AlignmentDirectional.centerStart,
                            child: FutureBuilder(
                              future: _placeMarks,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Placemark>> snapshot) {
                                if (snapshot.hasData) {
                                  final placeMark = snapshot.data![0];
                                  return TextButton(
                                    onPressed: () async {
                                      await LocationService()
                                          .openEventInMap(event);
                                    },
                                    child: Text(
                                      '${placeMark.street}, ${placeMark.postalCode}, ${placeMark.locality}',
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                        child: Text(
                      event.details,
                      style: const TextStyle(height: 1.5),
                    ))),
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
          if (currentUser.type == UserType.base &&
              event.startDate.isAfter(DateTime.now()))
            Container(
              margin: const EdgeInsets.all(20),
              child: CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'buy_tickets');
                },
                buttonText: 'Tickets hier kaufen',
              ),
            ),
          if (currentUser.type == UserType.guest)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const Text('Du willst Tickets kaufen? Dann registriere Dich'),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'activate_account');
                    },
                    buttonText: 'Aktiviere Account',
                  ),
                ],
              ),
            ),
          if (event.creatorId == currentUser.uid &&
              event.startDate.isAfter(DateTime.now()))
            Container(
              margin: const EdgeInsets.all(20),
              child: CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'edit_event');
                },
                buttonText: 'Beschreibung bearbeiten',
              ),
            ),
        ],
      ),
    );
  }

  String _getTimeText(Event event) {
    if (event.endDate == null) {
      return '${event.startDate.toString().substring(11, 16)} Uhr';
    } else {
      return '${event.startDate.toString().substring(11, 16)} - ${event.endDate.toString().substring(11, 16)} Uhr';
    }
  }

  void _showArtistsModal() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: dialogPadding,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
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
                    final artist = snapshot.data();
                    _imageUrl = StorageService().getUserImageUrl(artist.uid);

                    /// This is used twice, also in saved artists page TODO: merge into one widget
                    return GestureDetector(
                      onTap: () {
                        StateService().lastSelectedArtist = artist;
                        Navigator.pushNamed(context, 'artist_page');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                artist.imageUrl = snapshot.data;
                                return CircleAvatar(
                                  radius: 30,
                                  backgroundImage: snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? null
                                      : artist.imageUrl != null
                                          ? NetworkImage(artist.imageUrl!)
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
                          title: Text(artist.displayName),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Schliessen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getGenreWidgets() {
    final event = StateService().lastSelectedEvent!;
    if (event.genres.length > 3) {
      List<Widget> shortList = [];
      for (var i = 0; i < 3; i++) {
        shortList.add(Container(
            margin: const EdgeInsets.only(right: 18),
            child: Text(event.genres[i])));
      }
      shortList.add(Text('(+${event.genres.length - 3})'));
      return shortList;
    } else {
      return event.genres
          .map((e) => Container(
              margin: const EdgeInsets.only(right: 18), child: Text(e)))
          .toList();
    }
  }

  Future<void> _navigateToHost() async {
    var lastEvent = StateService().lastSelectedEvent!;
    final host = await UserDocService().getUserData(lastEvent.creatorId);
    if (host == null) return;
    StateService().lastSelectedHost = host;
    StateService().lastSelectedHost!.imageUrl =
        await StorageService().getUserImageUrl(host.uid);
    if (mounted) {
      Navigator.pushNamed(context, 'host_page');
    }
  }
}
