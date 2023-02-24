import 'package:event_finder/services/auth.service.dart';
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
  final _pageController = PageController();
  int _selectedPage = 0;
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
            children: [
              const EventsPage(),
              const ProfilePage(),
              Center(
                child: Scaffold(body: Center(child: Text('Hi ${AuthService().getCurrentFirebaseUser()?.displayName}'),), floatingActionButton: FloatingActionButton(child: const Icon(Icons.logout), onPressed: () {
                  AuthService().signOut().then((value) => Navigator.pushNamed(context, 'login'));
                  },),),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: '1',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: '2',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.personal_injury),
              label: '3',
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
