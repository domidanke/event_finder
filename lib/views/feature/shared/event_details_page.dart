import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:event_finder/widgets/kk_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'location_snippet.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final Event event = Provider.of<StateService>(context).lastSelectedEvent!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: event.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  event.imageUrl!,
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              )
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KKIcon(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(event.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                    )),
                                Card(
                                  //color: primaryColor,
                                  child: SizedBox(
                                      width: 50,
                                      height: 30,
                                      child: Center(
                                        child: Text(
                                          '${event.ticketPrice} €',
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const KKIcon(
                          icon: Icon(Icons.access_time),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.date.toString().substring(0, 10)),
                            Text(
                                '${event.date.toString().substring(11, 16)} Uhr')
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const KKIcon(icon: Icon(Icons.music_note)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(event.genre),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      height: 200,
                      child: LocationSnippet(
                          coordinates: event.locationCoordinates)),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 200,
                      child: SingleChildScrollView(
                          child: Text(
                        event.details,
                        style: const TextStyle(height: 1.5),
                      ))),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            if (AuthService().currentUser?.type == UserType.base)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: KKButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'buy_tickets');
                  },
                  buttonText: 'Tickets hier kaufen',
                ),
              ),
            if (AuthService().currentUser?.type == UserType.guest)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const Text(
                        'Du willst Tickets kaufen? Dann registriere Dich'),
                    const SizedBox(
                      height: 10,
                    ),
                    KKButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'activate_account');
                      },
                      buttonText: 'Aktiviere Account',
                    ),
                  ],
                ),
              ),
            if (event.creatorId == AuthService().currentUser!.uid)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: 200,
                  child: KKButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'edit_event');
                    },
                    buttonText: 'Event bearbeiten',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
