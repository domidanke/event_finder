import 'package:event_finder/models/consts.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage.service.dart';
import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  void initState() {
    // TODO: implement initState
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
                future: StorageService().getEventImageUrl(event: widget.event),
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
                            //color: Colors.white,
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.event.date.day.toString(),
                                    //style: const TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    monthMap[
                                        widget.event.date.month.toString()]!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (AuthService().currentUser?.type == UserType.base)
                            StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      AuthService()
                                          .toggleSavedEvent(widget.event.uid);
                                    });
                                    await FirestoreService()
                                        .toggleSaveEventForUser(widget.event);
                                  },
                                  icon: AuthService()
                                          .currentUser!
                                          .savedEvents
                                          .contains(widget.event.uid)
                                      ? const Icon(Icons.favorite)
                                      : const Icon(Icons.favorite_border));
                            }),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Card(
                                //color: primaryColor,
                                child: SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: Center(
                                      child: Text(
                                        '${widget.event.ticketPrice} €',
                                      ),
                                    )),
                              ),
                              Card(
                                child: SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: Center(
                                      child: Text(
                                        widget.event.genre,
                                      ),
                                    )),
                              ),
                            ],
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

                              Text(
                                widget.event.creatorName,
                                style: const TextStyle(fontSize: 16),
                              ),

                              /// TODO get local distance to address?
                              const Text(
                                '1.5km',
                                style: TextStyle(fontSize: 16),
                              )
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
}
