import 'package:event_finder/models/consts.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/models/theme.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage.service.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StorageService().getEventImageUrl(eventTitle: event.title),
      builder: (context, snapshot) {
        event.imageUrl = snapshot.data;
        return GestureDetector(
          onTap: () {
            StateService().lastSelectedEvent = event;
            Navigator.pushNamed(context, 'event_details');
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
                height: 250,
                decoration: BoxDecoration(
                  image: event.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(
                            event.imageUrl!,
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
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
                            color: Colors.white,
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    event.date.day.toString(),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  Text(monthMap[event.date.month.toString()]!,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite_border))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: primaryColor,
                            child: SizedBox(
                                width: 50,
                                height: 30,
                                child: Center(
                                  child: Text(
                                    '${event.ticketPrice} €',
                                  ),
                                )),
                          ),
                          Text(
                            event.title,
                            style: const TextStyle(fontSize: 24),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${event.date.hour}:${event.date.minute == 0 ? '00' : event.date.minute} Uhr',
                                style: const TextStyle(fontSize: 16),
                              ),

                              /// TODO get city of address
                              Text(
                                event.address,
                                style: const TextStyle(fontSize: 16),
                              ),

                              /// TODO get local distance to address
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
          ),
        );
      },
    );
  }
}
