import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/event_rating.service.dart';
import 'package:flutter/material.dart';

import '../services/date.service.dart';
import '../services/storage/storage.service.dart';
import '../theme/theme.dart';

class RatingEventTile extends StatefulWidget {
  const RatingEventTile({super.key, required this.event});
  final Event event;

  @override
  State<RatingEventTile> createState() => _RatingEventTileState();
}

class _RatingEventTileState extends State<RatingEventTile> {
  late Future<String> _eventImageUrlFuture;

  @override
  void initState() {
    _eventImageUrlFuture = StorageService().getEventImageUrl(
        eventId: widget.event.uid, hostId: widget.event.creatorId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isAvailableToRate(widget.event.startDate) ? 1 : 0.3,
      child: GestureDetector(
        onTap: () {
          if (!_isAvailableToRate(widget.event.startDate)) return;
          EventRatingService().selectedEventToRate = widget.event;
          Navigator.pushNamed(context, 'event_rating');
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
                        text: widget.event.creatorName,
                        style: const TextStyle(
                            fontSize: 14, color: secondaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!_isAvailableToRate(widget.event.startDate))
              const Expanded(
                  child: Text(
                'Bald möglich',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              )),
            if (_isAvailableToRate(widget.event.startDate))
              const Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 32,
                      ))),
            const SizedBox(
              width: 18,
            ),
          ],
        ),
      ),
    );
  }

  bool _isAvailableToRate(DateTime date) {
    // Needs to be at least 24 hours since the start of the event
    final now = DateTime.now();
    final dayAgo = DateTime(now.year, now.month, now.day - 1);
    return date.isBefore(dayAgo);
  }
}
