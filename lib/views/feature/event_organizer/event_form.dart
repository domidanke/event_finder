import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/alert.service.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventForm extends StatefulWidget {
  const EventForm({super.key});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String text;
  TextEditingController dateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 500,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Title',border: OutlineInputBorder(),),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          title = value;
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: dateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a date';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Date',
                        ),
                        onTap: () async {
                          final selectedDate = await _showIosDatePicker(context);
                          setState(() {
                            dateController.text =
                                selectedDate.toString().substring(0, 16);
                            _selectedDate = selectedDate;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Text', border: OutlineInputBorder(),),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          text = value;
                          return null;
                        },
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final event = Event(
                                  title: title,
                                  text: text,
                                  date: _selectedDate!,
                                );
                                try {
                                  await FirestoreService().writeEventToFirebase(event).then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Event erstellt.')),
                                    );
                                    Future.delayed(const Duration(seconds: 2)).then((value) => Navigator.pop(context));
                                  });
                                } catch(e) {
                                  AlertService()
                                      .showAlert('Event erstellen fehlgeschlagen', e.toString(), context);
                                }
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime> _showIosDatePicker(context) async {
    late DateTime pickedDate = DateTime.now();
    await showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 190,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              SizedBox(
                height: 180,
                child: CupertinoDatePicker(
                    use24hFormat: true,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (val) {
                      pickedDate = val;
                    }),
              ),
            ],
          ),
        ));
    return pickedDate;
  }
}
