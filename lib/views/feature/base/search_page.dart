import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/base/artist_search.dart';
import 'package:event_finder/views/feature/base/host_search.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;

  List<Widget> searchWidgetOptions = [
    const HostSearch(),
    const ArtistSearch(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              child: Container(
                color: _selectedIndex == 0 ? primaryColor : primaryWhite,
                child: Row(
                  children: const [
                    Icon(
                      Icons.house,
                    ),
                    VerticalDivider(),
                    Text('Hosts')
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: Container(
                color: _selectedIndex == 1 ? primaryColor : primaryWhite,
                child: Row(
                  children: const [
                    Icon(
                      Icons.people,
                    ),
                    VerticalDivider(),
                    Text('Artists')
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: searchWidgetOptions[_selectedIndex],
        )
      ],
    );
  }
}
