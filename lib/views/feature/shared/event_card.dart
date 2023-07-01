import 'package:event_finder/models/consts.dart';
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
    _eventImageUrlFuture =
        StorageService().getEventImageUrl(event: widget.event);
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
      child: AspectRatio(
        aspectRatio: 3 / 3,
        child: Card(
          color: primaryGrey.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: primaryWhite, width: 0.2),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: [
              FutureBuilder(
                  future: _eventImageUrlFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    widget.event.imageUrl = snapshot.data;
                    return Container(
                      decoration: BoxDecoration(
                        image: widget.event.imageUrl != null
                            ? DecorationImage(
                                image:
                                    NetworkImage(widget.event.imageUrl ?? ''),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : null,
                    );
                  }),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 75,
                      height: 75,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side:
                              const BorderSide(color: secondaryColor, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.event.startDate.day.toString(),
                              style: const TextStyle(
                                  fontSize: 24, color: secondaryColor),
                            ),
                            Text(
                              monthMap[
                                  widget.event.startDate.month.toString()]!,
                              style: const TextStyle(
                                  fontSize: 18, color: secondaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Row(
                            children: widget.event.genres
                                .map(
                                  (genre) => GenreCard(text: genre),
                                )
                                .toList(),
                          ),
                        ),
                        FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              widget.event.title,
                              style: const TextStyle(
                                  fontSize: 32, color: secondaryColor),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _getTimeText(),
                                style: const TextStyle(
                                    fontSize: 16, color: secondaryColor),
                              ),
                              _getDistanceWidget()
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeText() {
    if (widget.event.endDate == null) {
      return '${widget.event.startDate.toString().substring(11, 16)} Uhr';
    } else {
      return '${widget.event.startDate.toString().substring(11, 16)} - ${widget.event.endDate.toString().substring(11, 16)} Uhr';
    }
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
      return const Text(
        'kein GPS',
        style: TextStyle(color: secondaryColor),
      );
    }
    var currentLatLng =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    var eventLatLng = LatLng(widget.event.location.geoPoint.latitude,
        widget.event.location.geoPoint.longitude);
    return Text(
      '${LocationService().getDistanceFromLatLonInKm(currentLatLng, eventLatLng)}km',
      style: const TextStyle(fontSize: 16, color: secondaryColor),
    );
  }
}
