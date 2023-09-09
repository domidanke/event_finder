import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

import '../../../services/date.service.dart';
import '../../../services/location.service.dart';
import '../../../services/semi_circle_clipper.dart';
import '../../../widgets/qr_code.dart';

class TicketDetailsPage extends StatefulWidget {
  const TicketDetailsPage({Key? key}) : super(key: key);

  @override
  State<TicketDetailsPage> createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  final ticketInfo = StateService().lastSelectedTicket!;
  final PageController pageViewController = PageController();
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: secondaryGradient),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 42, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 32,
                        )),
                  ),
                  Expanded(
                    flex: 6,
                    child: Center(
                      child: ValueListenableBuilder<int>(
                        valueListenable: currentPageNotifier,
                        builder: (context, currentPage, _) {
                          return Text(
                            'Ticket ${(currentPage + 1)} von ${ticketInfo.ticketQrCodeIds.length}',
                            style: const TextStyle(fontSize: 20),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ClipPath(
              clipper: SemiCircleClipper(),
              child: Container(
                height: 400,
                width: 300,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 125,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8)),
                          image: DecorationImage(
                            image: NetworkImage(ticketInfo.imageUrl!),
                            fit: BoxFit.cover,
                          )),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Column(
                      children: [
                        Text(
                          ticketInfo.eventTitle,
                          style: const TextStyle(
                              fontSize: 20, color: primaryBackgroundColor),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 75),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: secondaryColor,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                DateService().getDateText(ticketInfo.startDate),
                                style: const TextStyle(color: secondaryColor),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 75),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.watch_later_outlined,
                                color: secondaryColor,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                DateService().getTimeText(
                                    ticketInfo.startDate, ticketInfo.endDate),
                                style: const TextStyle(color: secondaryColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 180,
                      child: PageView(
                        onPageChanged: (int page) {
                          currentPageNotifier.value = page;
                        },
                        controller: pageViewController,
                        children: [..._getQrCodeWidgets()],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    CustomIconButton(
                      icon: const Icon(Icons.event),
                      onPressed: () async {
                        final event = await EventDocService()
                            .getEventDocument(ticketInfo.eventId);
                        event!.imageUrl = await StorageService()
                            .getEventImageUrl(
                                eventId: event.uid, hostId: event.creatorId);
                        StateService().lastSelectedEvent = event;
                        if (mounted) {
                          Navigator.pushNamed(context, 'event_details');
                        }
                      },
                    ),
                    const Text('Zum Event'),
                  ],
                ),
                Column(
                  children: [
                    CustomIconButton(
                        onPressed: () async {
                          final event = await EventDocService()
                              .getEventDocument(ticketInfo.eventId);
                          await LocationService().openEventInMap(event!);
                        },
                        icon: const Icon(
                          Icons.alt_route,
                          size: 40,
                        )),
                    const Text('Route'),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _getQrCodeWidgets() {
    List<Widget> qrCodeWidgets = [];
    for (var i = 0; i < ticketInfo.ticketQrCodeIds.length; i++) {
      qrCodeWidgets.add(Center(
        child: QrCode(
          size: 180,
          data: ticketInfo.ticketQrCodeIds[i],
        ),
      ));
    }
    return qrCodeWidgets;
  }
}
