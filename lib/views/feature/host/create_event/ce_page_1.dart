import 'dart:io';

import 'package:event_finder/services/date.service.dart';
import 'package:event_finder/views/feature/shared/genre_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../models/event.dart';
import '../../../../services/create_event.service.dart';

class CePage1 extends StatefulWidget {
  const CePage1({Key? key}) : super(key: key);

  @override
  State<CePage1> createState() => _CePage1State();
}

class _CePage1State extends State<CePage1> {
  TextEditingController dateController = TextEditingController();
  TextEditingController androidTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Titel',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte geben Sie einen Titel ein';
              }
              CreateEventService().newEvent.title = value;
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          _getPlatformDateFields(CreateEventService().newEvent),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ticket Preis',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price';
              }
              CreateEventService().newEvent.ticketPrice = int.parse(value);
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const GenrePicker(),
        ],
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
              initialValue: CreateEventService().newEvent.date.toString(),
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
          if (dateController.text.isNotEmpty)
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
