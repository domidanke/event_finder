import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/ticket.service.dart';
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
  bool _isLoading = false;
  List<TicketNumberCard> numberCards = [];

  void _fillNumberCards() {
    int remainingTickets = StateService().lastSelectedEvent!.maxTickets -
        StateService().lastSelectedEvent!.soldTickets.length;
    int ticketsToSell = remainingTickets > 5 ? 5 : remainingTickets;
    for (var i = 1; i <= ticketsToSell; i++) {
      numberCards.add(
        TicketNumberCard(
          onTap: () {
            setState(() {
              TicketService().numberOfTicketsToBuy = i;
            });
          },
          ticketNumber: i,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fillNumberCards();
  }

  @override
  Widget build(BuildContext context) {
    final Event event = StateService().lastSelectedEvent!;
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
                            children: numberCards,
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
                      final ticketInfo = TicketService().createTicketInfo();
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
                        'Tickets jetzt kaufen ${event.ticketPrice * TicketService().numberOfTicketsToBuy}€',
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
                          Text(TicketService().numberOfTicketsToBuy.toString()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Preis: '),
                          Text(
                              '${TicketService().numberOfTicketsToBuy * event.ticketPrice}€'),
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
}

class TicketNumberCard extends StatefulWidget {
  const TicketNumberCard({
    Key? key,
    required this.onTap,
    required this.ticketNumber,
  }) : super(key: key);
  final int ticketNumber;
  final Function() onTap;

  @override
  State<TicketNumberCard> createState() => _TicketNumberCardState();
}

class _TicketNumberCardState extends State<TicketNumberCard> {
  @override
  Widget build(BuildContext context) {
    Provider.of<TicketService>(context).numberOfTicketsToBuy;
    return GestureDetector(
        onTap: widget.onTap,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: TicketService().numberOfTicketsToBuy == widget.ticketNumber
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
                    color: TicketService().numberOfTicketsToBuy ==
                            widget.ticketNumber
                        ? primaryBackgroundColor
                        : null),
              )),
        ));
  }
}
