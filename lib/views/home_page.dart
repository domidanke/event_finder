import 'package:event_finder/models/theme.dart';
import 'package:event_finder/views/feature/shared/KKDrawer.dart';
import 'package:event_finder/views/feature/shared/events_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0), child: AppBar()),
        drawer: const KKDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            gradient: primaryGradient,
          ),
          child: const SafeArea(
            child: EventsPage(),
          ),
        ),
      ),
    );
  }
}
