import 'dart:io';

import 'package:event_finder/services/date.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/genre_picker.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../models/event.dart';

class CreateEventPage1 extends StatefulWidget {
  const CreateEventPage1({Key? key}) : super(key: key);

  @override
  State<CreateEventPage1> createState() => _CreateEventPage1State();
}

class _CreateEventPage1State extends State<CreateEventPage1> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController androidTimeController = TextEditingController();

  @override
  void initState() {
    StateService().newEvent = NewEvent();
    super.initState();
  }

  @override
  void dispose() {
    StateService().resetSelectedGenres();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NewEvent newEvent = StateService().newEvent;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Expanded(
                  flex: 100,
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Titel',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          newEvent.title = value;
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _getPlatformDateFields(newEvent),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Ticket Preis',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType:
                            const TextInputType.numberWithOptions(signed: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          newEvent.ticketPrice = int.parse(value);
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const GenrePicker(),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    KKButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      buttonText: 'Abbrechen',
                    ),
                    KKButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            StateService().selectedGenres.isNotEmpty) {
                          newEvent.genres = StateService().selectedGenres;
                          Navigator.pushNamed(context, 'create_event_page_2');
                        }
                      },
                      buttonText: 'Weiter',
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPlatformDateFields(NewEvent newEvent) {
    if (Platform.isAndroid) {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
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
                final selectedDate =
                    await DateService().showPlatformDatePicker(context);
                setState(() {
                  dateController.text =
                      selectedDate.toString().substring(0, 10);
                  newEvent.date = selectedDate;
                });
              },
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: androidTimeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Uhrzeit',
              ),
              onTap: () async {
                final selectedTime =
                    await DateService().showAndroidTimePicker(context);
                setState(() {
                  androidTimeController.text =
                      '${selectedTime!.hour}:${selectedTime.minute} Uhr';
                  newEvent.date = DateTime(
                      newEvent.date.year,
                      newEvent.date.month,
                      newEvent.date.day,
                      selectedTime.hour,
                      selectedTime.minute);
                });
              },
            ),
          ),
        ],
      );
    } else {
      return TextFormField(
        readOnly: true,
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
          final selectedDate =
              await DateService().showPlatformDatePicker(context);
          setState(() {
            dateController.text = selectedDate.toString().substring(0, 16);
            newEvent.date = selectedDate;
          });
        },
      );
    }
  }
}
