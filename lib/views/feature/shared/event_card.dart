import 'package:event_finder/models/consts.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
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
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    child: snapshot.connectionState == ConnectionState.waiting
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
                                    monthMap[
                                        widget.event.date.month.toString()]!,
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
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        child: Text(
                                          genre,
                                        ),
                                      ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      return const Text('kein GPS');
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
}
