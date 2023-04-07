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

class MapEventCard extends StatefulWidget {
  final Event event;

  const MapEventCard({super.key, required this.event});

  @override
  State<MapEventCard> createState() => _MapEventCardState();
}

class _MapEventCardState extends State<MapEventCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.event.imageUrl == null) return;
        StateService().lastSelectedEvent = widget.event;
        Navigator.pushNamed(context, 'event_details');
      },
      child: SizedBox(
        width: 300,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          color: Colors.white,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.event.date.day.toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Text(
                                  monthMap[widget.event.date.month.toString()]!,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _getDistanceWidget()
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            widget.event.title,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
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
                      ],
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () async {
                            StateService().lastSelectedEvent = widget.event;
                            if (StateService().lastSelectedEvent!.imageUrl ==
                                null) {
                              StateService().lastSelectedEvent!.imageUrl =
                                  await StorageService()
                                      .getEventImageUrl(event: widget.event);
                            }
                            if (mounted) {
                              Navigator.pushNamed(context, 'event_details');
                            }
                          },
                          child: const Text('Details')),
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
}
