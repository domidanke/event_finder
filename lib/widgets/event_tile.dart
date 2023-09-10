import 'package:event_finder/models/event.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../services/date.service.dart';
import '../services/state.service.dart';
import '../services/storage/storage.service.dart';
import '../theme/theme.dart';

class EventTile extends StatefulWidget {
  const EventTile({super.key, required this.event});
  final Event event;

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  late Future<String> _eventImageUrlFuture;
  late Future<List<Placemark>> _placeMarks;

  @override
  void initState() {
    _eventImageUrlFuture = StorageService().getEventImageUrl(
        eventId: widget.event.uid, hostId: widget.event.creatorId);
    _placeMarks = placemarkFromCoordinates(
        widget.event.location.geoPoint.latitude,
        widget.event.location.geoPoint.longitude);
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
      child: Row(
        children: [
          FutureBuilder(
            future: _eventImageUrlFuture,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              widget.event.imageUrl = snapshot.data;
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
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
            },
          ),
          const SizedBox(
            width: 18,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.event.title,
                style: const TextStyle(fontSize: 22),
              ),
              Text(
                DateService().getDateText(widget.event.startDate),
                style: const TextStyle(color: secondaryColor),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: DateService().getTimeText(
                          widget.event.startDate, widget.event.endDate),
                      style:
                          const TextStyle(fontSize: 14, color: secondaryColor),
                    ),
                    const TextSpan(
                      text: ' | ',
                      style:
                          TextStyle(fontWeight: FontWeight.w100, fontSize: 18),
                    ),
                    TextSpan(
                      text: '${widget.event.ticketPrice.toString()}€',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: _placeMarks,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Placemark>> snapshot) {
                  if (snapshot.hasData) {
                    final placeMark = snapshot.data![0];
                    return Text(
                      '${placeMark.locality}',
                    );
                  }
                  return const Text('');
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
