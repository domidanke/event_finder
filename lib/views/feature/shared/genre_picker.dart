import 'package:event_finder/models/consts.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

class GenrePicker extends StatefulWidget {
  const GenrePicker({Key? key}) : super(key: key);
  @override
  State<GenrePicker> createState() => _GenrePickerState();
}

class _GenrePickerState extends State<GenrePicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 20,
            children: genres
                .map((genre) => StatefulBuilder(
                      builder: (BuildContext context,
                          void Function(void Function()) setState) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              StateService().toggleGenre(genre);
                            });
                          },
                          child: Card(
                            color: StateService().selectedGenres.contains(genre)
                                ? primaryColor
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(genre),
                            ),
                          ),
                        );
                      },
                    ))
                .toList(),
          ),
        ));
  }
}
