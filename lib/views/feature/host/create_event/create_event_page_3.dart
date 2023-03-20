import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../widgets/kk_button.dart';

class CreateEventPage3 extends StatefulWidget {
  const CreateEventPage3({Key? key}) : super(key: key);

  @override
  State<CreateEventPage3> createState() => _CreateEventPage3State();
}

class _CreateEventPage3State extends State<CreateEventPage3> {
  File? selectedImageFile;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: KKButton(
              onPressed: () async {
                print('Pick Location');
              },
              buttonText: 'Adresse finden'),
        ));
  }
}
