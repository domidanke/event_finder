import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/event_list.dart';
import 'package:flutter/material.dart';

class SavedEventsPage extends StatefulWidget {
  const SavedEventsPage({super.key});

  @override
  State<SavedEventsPage> createState() => _SavedEventsPageState();
}

class _SavedEventsPageState extends State<SavedEventsPage> {
  // Doing this so the modal sheet doesn't glitch weirdly
  Future<int> fetchNumber() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: primaryGradient),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 42),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 32,
                    )),
              ],
            ),
          ),
          FutureBuilder(
            future: fetchNumber(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                return Expanded(
                  child: EventList(
                    query: _getQuery(),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  Query<Event> _getQuery() {
    return EventDocService().eventsCollection.where(FieldPath.documentId,
        whereIn: StateService().currentUser!.savedEvents);
  }
}
