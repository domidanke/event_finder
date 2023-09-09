import 'package:event_finder/models/ticket_info.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

import '../services/date.service.dart';
import '../services/semi_circle_clipper.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          StateService().lastSelectedTicket = widget.ticketInfo;
          Navigator.pushNamed(context, 'ticket_details');
          // showModalBottomSheet<String>(
          //   context: context,
          //   isScrollControlled: true,
          //   builder: (BuildContext context) => const TicketDetailsPage(),
          // );
        },
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                FutureBuilder(
                  future: imageUrl,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                                  image:
                                      NetworkImage(widget.ticketInfo.imageUrl!),
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
                      ),
                    );
                  },
                ),
                if (widget.ticketInfo.ticketQrCodeIds.length > 1)
                  Container(
                    margin: const EdgeInsets.all(2),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: primaryWhite.withOpacity(0.8),
                    ),
                    child: Center(
                        child: Text(
                      '${widget.ticketInfo.ticketQrCodeIds.length}',
                      style: const TextStyle(color: primaryBackgroundColor),
                    )),
                  ),
              ],
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
