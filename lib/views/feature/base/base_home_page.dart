import 'package:event_finder/models/enums.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/base/search_page.dart';
import 'package:event_finder/views/feature/shared/events_page.dart';
import 'package:event_finder/views/feature/shared/profile_page.dart';
import 'package:flutter/material.dart';

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
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    if (StateService().currentUser!.type == UserType.guest && index == 0)
      return;
    setState(() {
      _selectedIndex = index;
    });
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
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Opacity(
                  opacity: StateService().currentUser!.type == UserType.guest
                      ? 0.2
                      : 1,
                  child: const Icon(Icons.search)),
              label: 'Suche',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Events',
            ),
            const BottomNavigationBarItem(
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
