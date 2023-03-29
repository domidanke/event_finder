import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/alert.service.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/widgets/kk_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditEventForm extends StatefulWidget {
  const EditEventForm({super.key});

  @override
  State<EditEventForm> createState() => _EditEventFormState();
}

class _EditEventFormState extends State<EditEventForm> {
  String details = '';

  Map<String, Object> generateMap() {
    Map<String, Object> map = {};
    if (details.isNotEmpty) {
      map.addAll({'details': details});
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color),
                decoration: const InputDecoration(
                  labelText: 'Beschreibung',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  details = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  KKIcon(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  KKIcon(
                    icon: const Icon(Icons.save),
                    onPressed: () async {
                      final Event event =
                          Provider.of<StateService>(context, listen: false)
                              .lastSelectedEvent!;
                      final map = generateMap();
                      if (map.isEmpty) return;
                      try {
                        await EventDocService()
                            .updateEventDocument(map, event.uid)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Beschreibung aktualisiert.')),
                          );
                          StateService().lastSelectedEventDetails = details;
                          Navigator.of(context).pop();
                        });
                      } catch (e) {
                        if (mounted) {
                          AlertService().showAlert(
                              'Event erstellen fehlgeschlagen',
                              e.toString(),
                              context);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
