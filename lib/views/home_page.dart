import 'package:event_finder/models/theme.dart';
import 'package:event_finder/views/feature/shared/KKDrawer.dart';
import 'package:event_finder/views/feature/shared/events_page.dart';
import 'package:event_finder/views/feature/shared/maps_page.dart';
import 'package:event_finder/widgets/kk_button.dart';
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
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0), child: AppBar()),
        drawer: const KKDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            gradient: primaryGradient,
          ),
          child: SafeArea(
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  _selectedPage = index;
                });
              },
              controller: _pageController,
              children: [
                Center(
                  child: KKButton(
                    buttonText: 'Neues Event',
                    onPressed: () {
                      Navigator.pushNamed(context, 'event_form');
                    },
                  ),
                ),
                const EventsPage(),
                const MapsPage()
              ],
            ),
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
          //selectedItemColor: Colors.tealAccent[800],
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
