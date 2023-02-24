import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/views/feature/shared/events_page.dart';
import 'package:event_finder/views/feature/shared/profile_page.dart';
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
    FirestoreService().setUserType();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: Scaffold(
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
              ProfilePage()
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
              icon: Icon(Icons.account_circle_sharp),
              label: 'Profile',
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
