import 'package:event_finder/views/feature/base/base_profile_page.dart';
import 'package:event_finder/views/feature/base/search_page.dart';
import 'package:event_finder/views/feature/shared/events_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class BaseHomePage extends StatefulWidget {
  const BaseHomePage({super.key});
  @override
  State<BaseHomePage> createState() => _BaseHomePageState();
}

class _BaseHomePageState extends State<BaseHomePage> {
  int _selectedIndex = 1;
  static const List<Widget> _widgetOptions = <Widget>[
    SearchPage(),
    EventsPage(),
    BaseProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    Geolocator.requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: Scaffold(
        body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Suche',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
