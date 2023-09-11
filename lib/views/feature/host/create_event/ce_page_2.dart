import 'package:event_finder/views/feature/shared/genre_picker.dart';
import 'package:flutter/material.dart';

class CePage2 extends StatefulWidget {
  const CePage2({Key? key}) : super(key: key);

  @override
  State<CePage2> createState() => _CePage2State();
}

class _CePage2State extends State<CePage2> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: GenrePicker());
  }
}
