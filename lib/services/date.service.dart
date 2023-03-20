import 'package:flutter/cupertino.dart';

class DateService {
  factory DateService() {
    return _singleton;
  }
  DateService._internal();
  static final DateService _singleton = DateService._internal();

  Future<DateTime> showIosDatePicker(context) async {
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
