import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateService {
  factory DateService() {
    return _singleton;
  }
  DateService._internal();
  static final DateService _singleton = DateService._internal();

  Future<DateTime> showPlatformDatePicker(context) async {
    late DateTime? selectedDate = DateTime.now();

    if (Platform.isAndroid) {
      selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + DateTime.now().year + 5));
      return selectedDate!;
    } else {
      await showModalBottomSheet(
          context: context,
          builder: (_) => SizedBox(
                height: 250,
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                          use24hFormat: true,
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged: (val) {
                            selectedDate = val;
                          }),
                    ),
                  ],
                ),
              ));
      return selectedDate!;
    }
  }

  Future<DateTime> showIosTimePicker(BuildContext context) async {
    late DateTime? selectedDate;
    await showModalBottomSheet(
        context: context,
        builder: (_) => SizedBox(
              height: 250,
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (val) {
                          selectedDate = val;
                        }),
                  ),
                ],
              ),
            ));
    return selectedDate!;
  }

  Future<TimeOfDay?> showAndroidTimePicker(context) async {
    return await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
  }
}
