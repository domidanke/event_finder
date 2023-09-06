import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

import '../models/consts.dart';
import '../services/state.service.dart';

class DateSelectionScroller extends StatefulWidget {
  const DateSelectionScroller({super.key});

  @override
  State<DateSelectionScroller> createState() => _DateSelectionState();
}

List<DateTime> generateDateList() {
  List<DateTime> dateList = [];
  DateTime now = DateTime.now();
  DateTime currentDate = DateTime(now.year, now.month, now.day);

  for (int i = 0; i < 21; i++) {
    dateList.add(currentDate.add(Duration(days: i)));
  }

  return dateList;
}

class _DateSelectionState extends State<DateSelectionScroller> {
  int selectedIndex = -1;
  List<DateTime> dateList = generateDateList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dateList.length,
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;
          final date = dateList[index];
          return Column(
            children: [
              Opacity(
                opacity: index == selectedIndex ? 1 : 0.4,
                child: Text(
                  '${weekdayMap[date.weekday]}',
                  style: TextStyle(
                    fontWeight: index == selectedIndex
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedIndex == index) {
                      selectedIndex = -1;
                      StateService().selectedDate = null;
                    } else {
                      selectedIndex = index;
                      StateService().selectedDate = dateList[index];
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.white : null,
                  ),
                  child: Text(
                    '${date.day < 10 ? '0${date.day}' : date.day}',
                    style: TextStyle(
                        fontWeight: index == selectedIndex
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: index == selectedIndex
                            ? primaryBackgroundColor
                            : primaryWhite),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DateItem extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final Function onPressed;

  DateItem(
      {required this.date, required this.isToday, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = date.day;
    final dayOfMonth = date.weekday;

    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        width: 100, // Adjust the width as needed
        padding: const EdgeInsets.all(8),
        color: isToday ? Colors.blue : Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${weekdayMap[dayOfMonth]}',
              style: TextStyle(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              '${dayOfWeek < 10 ? '0$dayOfWeek' : dayOfWeek}',
              style: TextStyle(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
