import 'package:event_finder/models/consts.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

class GenrePicker extends StatefulWidget {
  const GenrePicker({Key? key, required this.onGenreSelected})
      : super(key: key);
  final Function(String genreSelected) onGenreSelected;

  @override
  State<GenrePicker> createState() => _GenrePickerState();
}

class _GenrePickerState extends State<GenrePicker> {
  final List<String> _selectedGenres = [];

  @override
  void initState() {
    super.initState();
  }

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
                            widget.onGenreSelected(genre);
                            setState(() {
                              if (_selectedGenres.contains(genre)) {
                                _selectedGenres.remove(genre);
                              } else {
                                _selectedGenres.add(genre);
                              }
                            });
                          },
                          child: Card(
                            color: _selectedGenres.contains(genre)
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
