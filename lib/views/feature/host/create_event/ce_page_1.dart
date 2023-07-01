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
  TextEditingController iosEndTimeController = TextEditingController();
  TextEditingController androidStartTimeController = TextEditingController();
  TextEditingController androidEndTimeController = TextEditingController();

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
          const SizedBox(
            height: 6,
          ),
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
          Row(
            children: [
              Expanded(
                child: TextFormField(
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
                      return 'Ticket Preis fehlt';
                    }
                    CreateEventService().newEvent.ticketPrice =
                        int.parse(value);
                    return null;
                  },
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Anzahl',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ticket Anzahl fehlt';
                    }
                    CreateEventService().newEvent.maxTickets = int.parse(value);
                    return null;
                  },
                ),
              ),
            ],
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bitte geben Sie ein Datum ein';
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
                  newEvent.startDate = selectedDate;
                });
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: androidStartTimeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Uhrzeit fehlt';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Start',
              ),
              onTap: () async {
                final selectedTime =
                    await DateService().showAndroidTimePicker(context);
                setState(() {
                  androidStartTimeController.text =
                      '${selectedTime!.hour}:${selectedTime.minute.toString().length == 1 ? '0${selectedTime.minute}' : selectedTime.minute} Uhr';
                  newEvent.startDate = DateTime(
                      newEvent.startDate.year,
                      newEvent.startDate.month,
                      newEvent.startDate.day,
                      selectedTime.hour,
                      selectedTime.minute);
                });
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: androidEndTimeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ende',
              ),
              onTap: () async {
                final selectedTime =
                    await DateService().showAndroidTimePicker(context);
                setState(() {
                  androidEndTimeController.text =
                      '${selectedTime!.hour}:${selectedTime.minute.toString().length == 1 ? '0${selectedTime.minute}' : selectedTime.minute} Uhr';
                  newEvent.endDate = DateTime(
                      newEvent.startDate.year,
                      newEvent.startDate.month,
                      newEvent.startDate.day,
                      selectedTime.hour,
                      selectedTime.minute);
                });
              },
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: dateController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Datum fehlt';
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
                      selectedDate.toString().substring(0, 16);
                  newEvent.startDate = selectedDate;
                });
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: iosEndTimeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ende',
              ),
              onTap: () async {
                final selectedTime =
                    await DateService().showIosTimePicker(context);
                setState(() {
                  iosEndTimeController.text =
                      '${selectedTime.hour}:${selectedTime.minute.toString().length == 1 ? '0${selectedTime.minute}' : selectedTime.minute}';
                  newEvent.endDate = selectedTime;
                });
              },
            ),
          ),
        ],
      );
    }
  }
}
