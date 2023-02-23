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
                child: Text('Seite 1'),
              ),
              Center(
                child: Text('Seite 2'),
              ),
              Center(
                child: Text('Seite 3'),
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
