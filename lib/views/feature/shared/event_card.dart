import 'package:event_finder/models/consts.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/location.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late Future<String> _eventImageUrlFuture;
  late Future<String> _hostImageUrlFuture;
  String? _hostImageUrl;
  @override
  void initState() {
    _eventImageUrlFuture =
        StorageService().getEventImageUrl(event: widget.event);
    _hostImageUrlFuture =
        StorageService().getUserImageUrl(widget.event.creatorId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              FutureBuilder(
                  future: _hostImageUrlFuture,
                  builder: (context, snapshot) {
                    _hostImageUrl = snapshot.data;
                    return GestureDetector(
                      onTap: () async {
                        await _navigateToHost();
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            snapshot.connectionState == ConnectionState.waiting
                                ? null
                                : NetworkImage(_hostImageUrl!),
                        child:
                            snapshot.connectionState == ConnectionState.waiting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(),
                                  )
                                : null,
                      ),
                    );
                  }),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () async {
                  await _navigateToHost();
                },
                child: Text(
                  widget.event.creatorName,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const Spacer(),
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return IconButton(
                    onPressed: () async {
                      await UserDocService().saveEvent(widget.event.uid);
                      setState(() {
                        StateService().toggleSavedEvent(widget.event.uid);
                      });
                    },
                    icon: StateService()
                            .currentUser!
                            .savedEvents
                            .contains(widget.event.uid)
                        ? const Icon(Icons.bookmark)
                        : const Icon(Icons.bookmark_border));
              }),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        GestureDetector(
          onTap: () {
            if (widget.event.imageUrl == null) return;
            StateService().lastSelectedEvent = widget.event;
            Navigator.pushNamed(context, 'event_details');
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              children: [
                FutureBuilder(
                    future: _eventImageUrlFuture,
                    builder: (context, snapshot) {
                      widget.event.imageUrl = snapshot.data;
                      return Container(
                        height: 250,
                        decoration: BoxDecoration(
                          image: widget.event.imageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(widget.event.imageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child:
                            snapshot.connectionState == ConnectionState.waiting
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : null,
                      );
                    }),
                SizedBox(
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.event.date.day.toString(),
                                      ),
                                      Text(
                                        monthMap[widget.event.date.month
                                            .toString()]!,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Row(
                                  children: widget.event.genres
                                      .map(
                                        (genre) => Card(
                                          child: SizedBox(
                                              width: 50,
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  genre,
                                                ),
                                              )),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              Text(
                                widget.event.title,
                                style: const TextStyle(fontSize: 24),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${widget.event.date.toString().substring(11, 16)} Uhr',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  _getDistanceWidget()
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }

  Widget _getDistanceWidget() {
    if (StateService().currentUser!.type != UserType.base) {
      return const SizedBox(
        width: 70,
      );
    }
    final Position? currentPosition =
        Provider.of<StateService>(context).currentUserLocation;
    if (currentPosition == null) {
      return const Text('GPS deaktiviert');
    }
    var currentLatLng =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    var eventLatLng = LatLng(widget.event.location.geoPoint.latitude,
        widget.event.location.geoPoint.longitude);
    return Text(
      '${LocationService().getDistanceFromLatLonInKm(currentLatLng, eventLatLng)}km',
      style: const TextStyle(fontSize: 16),
    );
  }

  Future<void> _navigateToHost() async {
    final host = await UserDocService().getUserData(widget.event.creatorId);
    if (host == null) return;
    StateService().lastSelectedHost = host;
    StateService().lastSelectedHost!.imageUrl = _hostImageUrl;
    if (mounted) {
      Navigator.pushNamed(context, 'host_page');
    }
  }
}
