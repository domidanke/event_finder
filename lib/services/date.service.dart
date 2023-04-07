import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateService {
  factory DateService() {
    return _singleton;
  }
  DateService._internal();
  static final DateService _singleton = DateService._internal();

  Future<DateTime> showIosDatePicker(context) async {
    late DateTime? selectedDate = DateTime.now();

    if (Platform.isAndroid) {
      selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + DateTime.now().year + 5));
      return selectedDate!;
    } else {
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
                            selectedDate = val;
                          }),
                    ),
                  ],
                ),
              ));
      return selectedDate!;
    }
  }
}
