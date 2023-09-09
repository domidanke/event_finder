import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../../services/date.service.dart';
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
  //late Future<List<Placemark>> _placeMarks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          end: Alignment.topCenter,
          begin: Alignment.bottomCenter,
          colors: [
            secondaryColor.withOpacity(0.6),
            primaryColor,
          ],
        )),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.keyboard_arrow_down))
                  ],
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: currentPageNotifier,
                builder: (context, currentPage, _) {
                  return Text(
                    'Ticket ${(currentPage + 1)} von ${ticketInfo.ticketQrCodeIds.length}',
                    style: const TextStyle(fontSize: 22),
                  );
                },
              ),
              const SizedBox(
                height: 28,
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
                                  DateService()
                                      .getDateText(ticketInfo.startDate),
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
                        child: PageView.builder(
                          onPageChanged: (int page) {
                            currentPageNotifier.value = page;
                          },
                          controller: pageViewController,
                          itemCount: ticketInfo.ticketQrCodeIds.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                              child: QrCode(
                                size: 180,
                                data: ticketInfo.ticketQrCodeIds[0],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
