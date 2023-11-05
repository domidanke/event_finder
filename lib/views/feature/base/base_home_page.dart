import 'package:event_finder/services/alert.service.dart';
import 'package:event_finder/services/location.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/base/base_profile_page.dart';
import 'package:event_finder/views/feature/base/events_page.dart';
import 'package:event_finder/views/feature/base/search_page.dart';
import 'package:event_finder/views/feature/shared/events_map_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class BaseHomePage extends StatefulWidget {
  const BaseHomePage({super.key});
  @override
  State<BaseHomePage> createState() => _BaseHomePageState();
}

class _BaseHomePageState extends State<BaseHomePage> {
  int _selectedIndex = 2;
  static const List<Widget> _widgetOptions = <Widget>[
    EventsMapPage(),
    SearchPage(),
    EventsPage(),
    BaseProfilePage()
  ];

  void _onItemTapped(int index) async {
    if (index == 0 && StateService().currentUserLocation == null) {
      var permission = await Geolocator.checkPermission();
      if (permission.name == 'deniedForever') {
        if (mounted) {
          AlertService().showAlert('Zugriff auf Location benötigt.',
              'missing-location-permission', context);
        }
        return;
      } else {
        StateService().currentUserLocation =
            await Geolocator.getCurrentPosition();
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    LocationService().handlePermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: Column(
        children: [
          Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Entdecke',
                ),
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
        ],
      ),
    );
  }
}
