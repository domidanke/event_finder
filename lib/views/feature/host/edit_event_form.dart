import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/alert.service.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_icon_button.dart';

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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomIconButton(),
                  CustomIconButton(
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
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 15,
                decoration: const InputDecoration(
                  labelText: 'Beschreibung',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  details = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
