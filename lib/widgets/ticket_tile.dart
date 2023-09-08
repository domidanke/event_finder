import 'dart:math';

import 'package:event_finder/models/ticket_info.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

import '../services/date.service.dart';
import '../services/state.service.dart';
import '../services/storage/storage.service.dart';

class TicketTile extends StatefulWidget {
  const TicketTile({super.key, required this.ticketInfo});
  final TicketInfo ticketInfo;

  @override
  State<TicketTile> createState() => _TicketTileState();
}

class _TicketTileState extends State<TicketTile> {
  late Future<String> imageUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageUrl = StorageService().getEventImageUrl(
        eventId: widget.ticketInfo.eventId,
        hostId: widget.ticketInfo.creatorId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () {
          StateService().lastSelectedTicket = widget.ticketInfo;
          Navigator.pushNamed(context, 'ticket_details');
        },
        child: Row(
          children: [
            FutureBuilder(
              future: imageUrl,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                widget.ticketInfo.imageUrl = snapshot.data;
                return ClipPath(
                  clipper: SemiCircleClipper(),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: widget.ticketInfo.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(widget.ticketInfo.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : null,
                  ),
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
                  widget.ticketInfo.eventTitle,
                  style: const TextStyle(fontSize: 22),
                ),
                Text(
                  DateService().getDateText(widget.ticketInfo.startDate),
                  style: const TextStyle(color: secondaryColor),
                ),
                Text(
                  DateService().getTimeText(
                      widget.ticketInfo.startDate, widget.ticketInfo.endDate),
                  style: const TextStyle(color: secondaryColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SemiCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Move to the top left corner
    path.moveTo(0, 0);

    // Draw a straight line to the top right corner
    path.lineTo(size.width, 0);

    // Draw a straight line to the bottom right corner
    path.lineTo(size.width, size.height / 2);
// Draw two small semi-circles to remove from both sides
    const double radius = 12.0; // Adjust the radius as needed
    final double centerY = size.height / 2;
    // Right semi-circle (removal)
    path.arcTo(
      Rect.fromCircle(center: Offset(size.width, centerY), radius: radius),
      -90 * pi / 180,
      -3.14,
      false,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height / 2);

    path.arcTo(
      Rect.fromCircle(center: Offset(0, centerY), radius: radius),
      90 * pi / 180,
      -3.14,
      false,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
