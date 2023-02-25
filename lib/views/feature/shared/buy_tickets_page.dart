import 'package:flutter/material.dart';

class BuyTicketsPage extends StatefulWidget {
  const BuyTicketsPage({super.key});

  @override
  State<BuyTicketsPage> createState() => _BuyTicketsPageState();
}

class _BuyTicketsPageState extends State<BuyTicketsPage> {
  @override
  Widget build(BuildContext context) {
    //final Event event = Provider.of<StateService>(context).selectedEvent!;
    return const Scaffold(
      body: SafeArea(
          child: Center(
        child: Text('BUY TICKETS HERE'),
      )),
    );
  }
}
