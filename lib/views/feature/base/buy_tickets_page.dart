import 'package:event_finder/models/event.dart';
import 'package:event_finder/models/ticket_info.dart';
import 'package:event_finder/services/firestore/event_ticket_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/kk_button_async.dart';
import 'package:event_finder/widgets/kk_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Text(
                              event.title,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
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
                          'Menge',
                          style: TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    numberOfTickets = 1;
                                  });
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: numberOfTickets == 1
                                      ? primaryColor
                                      : null,
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 50,
                                      child: const Text(
                                        '1',
                                        style: TextStyle(fontSize: 24),
                                      )),
                                )),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    numberOfTickets = 2;
                                  });
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: numberOfTickets == 2
                                      ? primaryColor
                                      : null,
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 50,
                                      child: const Text(
                                        '2',
                                        style: TextStyle(fontSize: 24),
                                      )),
                                )),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    numberOfTickets = 3;
                                  });
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: numberOfTickets == 3
                                      ? primaryColor
                                      : null,
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 50,
                                      child: const Text(
                                        '3',
                                        style: TextStyle(fontSize: 24),
                                      )),
                                )),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    numberOfTickets = 4;
                                  });
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: numberOfTickets == 4
                                      ? primaryColor
                                      : null,
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 50,
                                      child: const Text(
                                        '4',
                                        style: TextStyle(fontSize: 24),
                                      )),
                                )),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    numberOfTickets = 5;
                                  });
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: numberOfTickets == 5
                                      ? primaryColor
                                      : null,
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 50,
                                      child: const Text(
                                        '5',
                                        style: TextStyle(fontSize: 24),
                                      )),
                                ))
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
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPaymentMethod = 'Paypal';
                            });
                          },
                          child: Card(
                            color: selectedPaymentMethod == 'Paypal'
                                ? primaryColor
                                : null,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              height: 50,
                              child: Row(
                                children: const [
                                  Icon(Icons.paypal),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Paypal',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPaymentMethod = 'Apple';
                            });
                          },
                          child: Card(
                            color: selectedPaymentMethod == 'Apple'
                                ? primaryColor
                                : null,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              height: 50,
                              child: Row(
                                children: const [
                                  Icon(Icons.apple),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Apple Pay',
                                    style: TextStyle(fontSize: 20),
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
                                ? primaryColor
                                : null,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              height: 50,
                              child: Row(
                                children: const [
                                  Icon(Icons.g_mobiledata),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Google Pay',
                                    style: TextStyle(fontSize: 20),
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
                child: KKButtonAsync(
                  loading: _isLoading,
                  onPressed: () async {
                    if (selectedPaymentMethod == null) return;
                    setState(() {
                      _isLoading = true;
                    });

                    /// TODO: Add Payment
                    await Future.delayed(const Duration(seconds: 1));
                    final ticketInfos = createIdsForQrCode();
                    await UserDocService().addUserTickets(ticketInfos);
                    StateService().addTickets(ticketInfos);
                    await EventTicketDocService()
                        .addTicketsToEvent(ticketInfos, event.uid);
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
                          Text(event.date.toString().substring(0, 16)),
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

  List<TicketInfo> createIdsForQrCode() {
    List<TicketInfo> ticketInfos = [];
    var dateAndTime = DateTime.now().toString().substring(0, 19);
    var event = StateService().lastSelectedEvent!;
    for (var i = 0; i < numberOfTickets; i++) {
      final ticketInfo = TicketInfo(
          id: '${StateService().currentUser!.uid}_${event.uid}_${dateAndTime}_${i + 1}/$numberOfTickets',
          eventTitle: event.title,
          eventDate: event.date);
      ticketInfos.add(ticketInfo);
    }
    return ticketInfos;
  }
}
