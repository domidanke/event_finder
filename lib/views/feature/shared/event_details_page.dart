import 'package:event_finder/models/event.dart';
import 'package:event_finder/models/theme.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:event_finder/widgets/kk_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                              const KKIcon(icon: Icon(Icons.favorite_border)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(fontSize: 24),
                              ),
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
                            ],
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(
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
                        Text('${event.date.toString().substring(11, 16)} Uhr')
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const KKIcon(icon: Icon(Icons.location_on)),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(event.address),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 200,
                    child: SingleChildScrollView(
                        child: Text(
                      event.details,
                      style: const TextStyle(height: 1.5),
                    ))),
              ],
            ),
            KKButton(
              onPressed: () {
                Navigator.pushNamed(context, 'buy_tickets');
              },
              buttonText: 'Tickets hier kaufen',
            )
          ],
        ),
      ),
    );
  }
}
