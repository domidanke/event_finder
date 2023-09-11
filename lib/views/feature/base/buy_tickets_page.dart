import 'package:event_finder/models/event.dart';
import 'package:event_finder/models/ticket_info.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/custom_button_async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/storage/storage.service.dart';
import '../../../widgets/custom_icon_button.dart';

class BuyTicketsPage extends StatefulWidget {
  const BuyTicketsPage({super.key});

  @override
  State<BuyTicketsPage> createState() => _BuyTicketsPageState();
}

class _BuyTicketsPageState extends State<BuyTicketsPage> {
  String? selectedPaymentMethod;
  int numberOfTickets = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Event event = Provider.of<StateService>(context).lastSelectedEvent!;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: AspectRatio(
                  aspectRatio: 5 / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
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
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 12),
                child: Text(
                  event.title,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Text(
                      'Von ',
                      style: TextStyle(
                          fontSize: 16, color: primaryWhite.withOpacity(0.5)),
                    ),
                    GestureDetector(
                      onTap: () async {
                        StateService().lastSelectedHost =
                            await UserDocService().getUserData(event.creatorId);
                        StateService().lastSelectedHost!.imageUrl =
                            await StorageService()
                                .getUserImageUrl(event.creatorId);
                        if (mounted) {
                          Navigator.pushNamed(context, 'host_page');
                        }
                      },
                      child: Text(
                        event.creatorName,
                        style: const TextStyle(
                            fontSize: 16, color: secondaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Menge',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              TicketNumberCard(
                                onTap: () {
                                  setState(() {
                                    numberOfTickets = 1;
                                  });
                                },
                                ticketNumber: 1,
                                numberOfTickets: numberOfTickets,
                              ),
                              TicketNumberCard(
                                onTap: () {
                                  setState(() {
                                    numberOfTickets = 2;
                                  });
                                },
                                ticketNumber: 2,
                                numberOfTickets: numberOfTickets,
                              ),
                              TicketNumberCard(
                                onTap: () {
                                  setState(() {
                                    numberOfTickets = 3;
                                  });
                                },
                                ticketNumber: 3,
                                numberOfTickets: numberOfTickets,
                              ),
                              TicketNumberCard(
                                onTap: () {
                                  setState(() {
                                    numberOfTickets = 4;
                                  });
                                },
                                ticketNumber: 4,
                                numberOfTickets: numberOfTickets,
                              ),
                              TicketNumberCard(
                                onTap: () {
                                  setState(() {
                                    numberOfTickets = 5;
                                  });
                                },
                                ticketNumber: 5,
                                numberOfTickets: numberOfTickets,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Zahlungsmethode',
                            style: TextStyle(fontSize: 18),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     setState(() {
                          //       selectedPaymentMethod = 'Paypal';
                          //     });
                          //   },
                          //   child: Card(
                          //     color: selectedPaymentMethod == 'Paypal'
                          //         ? secondaryColor
                          //         : null,
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10)),
                          //     child: Container(
                          //       margin:
                          //           const EdgeInsets.symmetric(horizontal: 16),
                          //       height: 50,
                          //       child: Row(
                          //         children: [
                          //           Icon(
                          //             Icons.paypal,
                          //             color: selectedPaymentMethod == 'Paypal'
                          //                 ? primaryBackgroundColor
                          //                 : null,
                          //           ),
                          //           const SizedBox(
                          //             width: 10,
                          //           ),
                          //           Text(
                          //             'Paypal',
                          //             style: TextStyle(
                          //                 fontSize: 20,
                          //                 color: selectedPaymentMethod == 'Paypal'
                          //                     ? primaryBackgroundColor
                          //                     : null),
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPaymentMethod = 'Apple';
                              });
                            },
                            child: Card(
                              color: selectedPaymentMethod == 'Apple'
                                  ? secondaryColor
                                  : null,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                height: 50,
                                child: Row(
                                  children: [
                                    Icon(Icons.apple,
                                        color: selectedPaymentMethod == 'Apple'
                                            ? primaryBackgroundColor
                                            : primaryWhite),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Apple Pay',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              selectedPaymentMethod == 'Apple'
                                                  ? primaryBackgroundColor
                                                  : primaryWhite),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPaymentMethod = 'Google';
                              });
                            },
                            child: Card(
                              color: selectedPaymentMethod == 'Google'
                                  ? secondaryColor
                                  : null,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                height: 50,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.g_mobiledata,
                                      color: selectedPaymentMethod == 'Google'
                                          ? primaryBackgroundColor
                                          : primaryWhite,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Google Pay',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              selectedPaymentMethod == 'Google'
                                                  ? primaryBackgroundColor
                                                  : primaryWhite),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Opacity(
                  opacity: selectedPaymentMethod == null ? 0.4 : 1,
                  child: CustomButtonAsync(
                    loading: _isLoading,
                    onPressed: () async {
                      if (selectedPaymentMethod == null) return;
                      setState(() {
                        _isLoading = true;
                      });

                      /// TODO: Add Payment
                      await Future.delayed(const Duration(seconds: 1));
                      final ticketInfo = createTicketInfo();
                      await UserDocService().addUserTickets(ticketInfo);
                      StateService().addTicket(ticketInfo);
                      await EventDocService().addSoldTicketsToEvent(
                          ticketInfo.ticketQrCodeIds, event.uid);
                      setState(() {
                        _isLoading = false;
                      });
                      if (mounted) {
                        _showConfirmationDialog();
                      }
                    },
                    buttonText:
                        'Tickets jetzt kaufen ${event.ticketPrice * numberOfTickets}€',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    final event = StateService().lastSelectedEvent!;
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              const Text('Ticketkauf erfolgreich'),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Event: '),
                          Text(event.title),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Datum: '),
                          Text(_getTimeText(event)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tickets: '),
                          Text(numberOfTickets.toString()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Preis: '),
                          Text('${numberOfTickets * event.ticketPrice}€'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    child: const Text('Schliessen'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                      Navigator.pushNamed(context, 'tickets');
                    },
                    child: const Text('Meine Tickets'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeText(Event event) {
    if (event.endDate == null) {
      return '${event.startDate.toString().substring(11, 16)} Uhr';
    } else {
      return '${event.startDate.toString().substring(11, 16)} - ${event.endDate.toString().substring(11, 16)} Uhr';
    }
  }

  TicketInfo createTicketInfo() {
    var dateAndTime = DateTime.now().toString().substring(0, 19);
    var event = StateService().lastSelectedEvent!;
    final ticketInfo = TicketInfo(
        ticketQrCodeIds: [],
        userId: StateService().currentUser!.uid,
        eventId: event.uid,
        creatorId: event.creatorId,
        creatorName: event.creatorName,
        eventTitle: event.title,
        startDate: event.startDate,
        endDate: event.endDate,
        ticketPrice: event.ticketPrice);
    for (var i = 0; i < numberOfTickets; i++) {
      ticketInfo.ticketQrCodeIds.add(
          '${StateService().currentUser!.uid}_${event.creatorId}_${event.creatorName}_${event.uid}_${dateAndTime}_${i + 1}/$numberOfTickets');
    }
    return ticketInfo;
  }
}

class TicketNumberCard extends StatefulWidget {
  const TicketNumberCard(
      {Key? key,
      required this.onTap,
      required this.ticketNumber,
      required this.numberOfTickets})
      : super(key: key);
  final int ticketNumber;
  final int numberOfTickets;
  final Function() onTap;

  @override
  State<TicketNumberCard> createState() => _TicketNumberCardState();
}

class _TicketNumberCardState extends State<TicketNumberCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: widget.numberOfTickets == widget.ticketNumber
              ? secondaryColor
              : null,
          child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 50,
              child: Text(
                '${widget.ticketNumber}',
                style: TextStyle(
                    fontSize: 24,
                    color: widget.numberOfTickets == widget.ticketNumber
                        ? primaryBackgroundColor
                        : null),
              )),
        ));
  }
}
