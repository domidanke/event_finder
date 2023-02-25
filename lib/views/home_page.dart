import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/views/feature/shared/events_page.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController(initialPage: 1);
  int _selectedPage = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const UserAvatar(
                      size: 80,
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    Text(
                      '${AuthService().getCurrentFirebaseUser()?.displayName}',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      '${AuthService().getCurrentFirebaseUser()?.email}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.receipt),
                title: const Text('Meine Tickets'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Meine Follows'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.event_available),
                title: const Text('Gespeicherte Veranstaltungen'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle_sharp),
                title: const Text('Mein Account'),
                onTap: () {
                  Navigator.pushNamed(context, 'profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Support'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: PageView(
            onPageChanged: (index) {
              setState(() {
                _selectedPage = index;
              });
            },
            controller: _pageController,
            children: const [
              Center(
                child: Text('Noch nicht gemacht'),
              ),
              EventsPage(),
              Center(
                child: Text('Noch nicht gemacht'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
          ],
          currentIndex: _selectedPage,
          selectedItemColor: Colors.tealAccent[800],
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 250),
                curve: Curves.decelerate);
          },
        ),
      ),
    );
  }
}
