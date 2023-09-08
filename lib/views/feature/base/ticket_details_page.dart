import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/qr_code.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../../../models/event.dart';
import '../../../services/location.service.dart';
import '../../../widgets/custom_icon_button.dart';

class TicketDetailsPage extends StatefulWidget {
  const TicketDetailsPage({Key? key}) : super(key: key);

  @override
  State<TicketDetailsPage> createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  final ticketInfo = StateService().lastSelectedTicket!;
  late Future<Event?> _eventFuture;
  late Future<List<Placemark>> _placeMarks;

  @override
  void initState() {
    // _eventFuture =
    //     EventDocService().getEventDocument(ticketInfo.qrCodeId.split('_')[1]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CustomIconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: _eventFuture,
              builder: (BuildContext context, AsyncSnapshot<Event?> snapshot) {
                if (!snapshot.hasData) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasData) {
                  final event = snapshot.data!;
                  _placeMarks = placemarkFromCoordinates(
                      event.location.geoPoint.latitude,
                      event.location.geoPoint.longitude);
                  return Expanded(
                    child: Column(
                      children: [
                        Text(
                          //'${ticketInfo.eventTitle} (${ticketInfo.qrCodeId.split('_')[3]})',
                          '',
                          style: const TextStyle(
                              fontSize: 28, color: secondaryColor),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              event.startDate.toString().substring(0, 10),
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  event.startDate.toString().substring(11, 16),
                                  style: const TextStyle(fontSize: 18),
                                ),
                                if (event.endDate != null)
                                  Text(
                                    '-${event.endDate.toString().substring(11, 16)}Uhr',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          event.creatorName,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        FutureBuilder(
                          future: _placeMarks,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Placemark>> snapshot) {
                            if (snapshot.hasData) {
                              final placeMark = snapshot.data![0];
                              return TextButton(
                                onPressed: () async {
                                  await LocationService().openEventInMap(event);
                                },
                                child: Text(
                                  '${placeMark.street}, ${placeMark.postalCode}, ${placeMark.locality}',
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                        const Spacer(),
                        QrCode(
                          size: 250,
                          data: 'ticketInfo.qrCodeId',
                        ),
                        const Spacer()
                      ],
                    ),
                  );
                } else {
                  return Expanded(child: Container());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
