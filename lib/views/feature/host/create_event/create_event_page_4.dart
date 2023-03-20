import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../widgets/kk_button.dart';

class CreateEventPage4 extends StatefulWidget {
  const CreateEventPage4({Key? key}) : super(key: key);

  @override
  State<CreateEventPage4> createState() => _CreateEventPage4State();
}

class _CreateEventPage4State extends State<CreateEventPage4> {
  File? selectedImageFile;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: KKButton(
              onPressed: () async {
                print('Search Artist');
              },
              buttonText: 'Kuenstler hinzufuegen'),
        ));
  }
}
