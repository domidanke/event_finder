import 'package:event_finder/views/feature/base/host_search.dart';
import 'package:event_finder/views/feature/shared/artist_search.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
        const SizedBox(
          height: 10,
        ),
        TabBar(
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.house)),
            Tab(icon: Icon(Icons.people)),
          ],
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(80.0),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: searchWidgetOptions[_selectedIndex],
        )
      ],
    );
  }
}
