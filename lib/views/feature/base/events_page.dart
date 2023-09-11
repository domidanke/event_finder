import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/shared/genre_picker.dart';
import 'package:event_finder/widgets/custom_button.dart';
import 'package:event_finder/widgets/date_selection_scroller.dart';
import 'package:event_finder/widgets/event_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/events_page.service.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late Future<String> _hostImageUrlFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<EventsPageService>(context).selectedDate;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Opacity(
                    opacity: StateService().currentUser!.type == UserType.guest
                        ? 0.2
                        : 1,
                    child: IconButton(
                      icon: Badge(
                        isLabelVisible:
                            StateService().selectedGenres.isNotEmpty,
                        label: Text('${StateService().selectedGenres.length}'),
                        child: const Icon(
                          Icons.filter_alt,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (StateService().currentUser!.type ==
                            UserType.guest) {
                          return;
                        }
                        _showFiltersSheet();
                      },
                    ),
                  )
                ],
              ),
              const DateSelectionScroller(),
              const Divider(
                height: 10,
              ),
              const SizedBox(
                height: 4,
              ),
              Expanded(
                child: EventList(
                  query: _getQuery(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Query<Event> _getQuery() {
    final now = DateTime.now();
    var startOfDay = DateTime(now.year, now.month, now.day);
    var query = EventDocService().eventsCollection.orderBy('startDate');

    if (EventsPageService().selectedDate != null) {
      startOfDay = EventsPageService().selectedDate!;
      final endOfDay =
          DateTime(startOfDay.year, startOfDay.month, startOfDay.day + 1);
      query = query.where('startDate', isLessThanOrEqualTo: endOfDay);
    }

    query = query.where('startDate', isGreaterThanOrEqualTo: startOfDay);

    if (StateService().selectedGenres.isNotEmpty) {
      query = query.where('genres',
          arrayContainsAny: StateService().selectedGenres);
    }

    return query;
  }

  void _showFiltersSheet() {
    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 250, child: GenrePicker()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                    onPressed: () {
                      StateService().resetSelectedGenres();
                      Navigator.pop(context);
                      setState(() {});
                    },
                    buttonText: 'Reset'),
                CustomButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    buttonText: 'Anwenden')
              ],
            )
          ],
        ),
      ),
    );
  }
}
