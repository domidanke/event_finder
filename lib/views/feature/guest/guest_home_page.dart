import 'package:event_finder/views/feature/base/events_page.dart';
import 'package:event_finder/views/feature/guest/guest_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GuestHomePage extends StatefulWidget {
  const GuestHomePage({super.key});
  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  int _selectedIndex = 2;
  static const List<Widget> _widgetOptions = <Widget>[
    Placeholder(),
    Placeholder(),
    EventsPage(),
    GuestProfilePage()
  ];

  void _onItemTapped(int index) {
    if (index == 0 || index == 1) return;
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
              icon: Opacity(opacity: 0.2, child: Icon(Icons.map)),
              label: 'Karte',
            ),
            BottomNavigationBarItem(
              icon: Opacity(opacity: 0.2, child: Icon(Icons.search)),
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
