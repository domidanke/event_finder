import 'dart:io';

import 'package:event_finder/models/consts.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/alert.service.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/services/storage.service.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EventForm extends StatefulWidget {
  const EventForm({super.key});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String details;
  late int ticketPrice;
  late String address;
  TextEditingController dateController = TextEditingController();
  DateTime? _selectedDate;
  File? selectedImageFile;

  String selectedGenre = genres.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: [
              TextFormField(
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color),
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  title = value;
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color),
                controller: dateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Datum',
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
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color),
                decoration: const InputDecoration(
                  labelText: 'Addresse',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  address = value;
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color),
                decoration: const InputDecoration(
                  labelText: 'Beschreibung',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  details = value;
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color),
                decoration: const InputDecoration(
                  labelText: 'Ticket Preis',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  ticketPrice = int.parse(value);
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: DropdownButton<String>(
                  value: selectedGenre,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  onChanged: (String? value) {
                    setState(() {
                      selectedGenre = value!;
                    });
                  },
                  items: genres.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KKButton(
                      onPressed: () async {
                        final XFile? image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image == null) return;
                        setState(() {
                          selectedImageFile = File(image.path);
                        });
                      },
                      buttonText: 'Bild hochladen'),
                  SizedBox(
                    width: 100,
                    child: Text(
                      selectedImageFile != null ? 'Image ready' : '',
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              KKButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      selectedImageFile != null &&
                      _selectedDate != null) {
                    final event = Event(
                        title: title,
                        details: details,
                        address: address,
                        date: _selectedDate!,
                        genre: selectedGenre,
                        creatorId: AuthService().getCurrentFirebaseUser()!.uid,
                        creatorName: AuthService()
                                .getCurrentFirebaseUser()!
                                .displayName ??
                            '',
                        ticketPrice: ticketPrice);

                    await FirestoreService()
                        .addEventDocument(event)
                        .then((String eventId) async {
                      await StorageService()
                          .saveEventImageToStorage(eventId, selectedImageFile!)
                          .then((value) => {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Event erstellt.')),
                                ),
                                Future.delayed(const Duration(seconds: 2))
                                    .then((value) => Navigator.pop(context)),
                              })
                          .catchError((e) {
                        AlertService().showAlert(
                            'Event Bild hochladen fehlgeschlagen',
                            e.toString(),
                            context);
                      });
                    }).catchError((e) {
                      AlertService().showAlert('Event erstellen fehlgeschlagen',
                          e.toString(), context);
                    });
                  }
                },
                buttonText: 'Erstellen',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime> _showIosDatePicker(context) async {
    late DateTime pickedDate = DateTime.now();
    await showCupertinoModalPopup(
        context: context,
        builder: (_) => SizedBox(
              height: 190,
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
