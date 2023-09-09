import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/location.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/genre_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../services/date.service.dart';
import '../../../widgets/save_event_button.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late Future<String> _eventImageUrlFuture;

  @override
  void initState() {
    _eventImageUrlFuture = StorageService().getEventImageUrl(
        eventId: widget.event.uid, hostId: widget.event.creatorId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.event.imageUrl == null) return;
        StateService().lastSelectedEvent = widget.event;
        Navigator.pushNamed(context, 'event_details');
      },
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 5 / 3,
            child: Card(
              color: primaryGrey.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: primaryWhite, width: 0.5),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  FutureBuilder(
                      future: _eventImageUrlFuture,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        widget.event.imageUrl = snapshot.data;
                        return Container(
                          decoration: BoxDecoration(
                            image: widget.event.imageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                        widget.event.imageUrl ?? ''),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : null,
                        );
                      }),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Opacity(
                        opacity:
                            StateService().currentUser!.type == UserType.guest
                                ? 0.2
                                : 1,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SaveEventButton(
                            event: widget.event,
                          ),
                        ));
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          widget.event.title,
                          style: const TextStyle(
                              fontSize: 20, color: primaryWhite),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: DateService()
                                      .getDateText(widget.event.startDate),
                                  style: const TextStyle(
                                      fontSize: 14, color: secondaryColor),
                                ),
                                const TextSpan(
                                  text: ' | ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 18),
                                ),
                                TextSpan(
                                  text: DateService().getTimeText(
                                      widget.event.startDate,
                                      widget.event.endDate),
                                  style: const TextStyle(
                                      fontSize: 14, color: secondaryColor),
                                ),
                                const TextSpan(
                                  text: ' | ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 18),
                                ),
                                TextSpan(
                                  text:
                                      '${widget.event.ticketPrice.toString()}€',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          _getDistanceWidget()
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          ...widget.event.genres
                              .map(
                                (genre) => GenreCard(text: genre),
                              )
                              .take(3)
                              .toList(),
                          if (widget.event.genres.length > 3)
                            GenreCard(
                                text:
                                    '+${(widget.event.genres.length - 3).toString()}')
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
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
      return Text(
        'kein GPS',
        style: TextStyle(color: primaryWhite.withOpacity(0.6)),
      );
    }
    var currentLatLng =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    var eventLatLng = LatLng(widget.event.location.geoPoint.latitude,
        widget.event.location.geoPoint.longitude);
    return Text(
      '${LocationService().getDistanceFromLatLonInKm(currentLatLng, eventLatLng)}km',
      style: TextStyle(fontSize: 16, color: primaryWhite.withOpacity(0.6)),
    );
  }
}
