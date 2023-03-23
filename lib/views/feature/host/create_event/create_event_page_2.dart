import 'dart:io';

import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widgets/kk_button.dart';

class CreateEventPage2 extends StatefulWidget {
  const CreateEventPage2({Key? key}) : super(key: key);

  @override
  State<CreateEventPage2> createState() => _CreateEventPage2State();
}

class _CreateEventPage2State extends State<CreateEventPage2> {
  @override
  Widget build(BuildContext context) {
    NewEvent newEvent = StateService().newEvent;
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const Spacer(),
                if (newEvent.selectedImageFile == null)
                  KKButton(
                      onPressed: () async {
                        final XFile? image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image == null) return;
                        setState(() {
                          newEvent.selectedImageFile = File(image.path);
                        });
                      },
                      buttonText: 'Bild hochladen'),
                if (newEvent.selectedImageFile != null)
                  Image.file(newEvent.selectedImageFile!),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    KKButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      buttonText: 'Zurueck',
                    ),
                    Opacity(
                      opacity: newEvent.selectedImageFile == null ? 0.4 : 1,
                      child: KKButton(
                        onPressed: () {
                          if (newEvent.selectedImageFile == null) {
                            return;
                          }
                          Navigator.pushNamed(context, 'create_event_page_3');
                        },
                        buttonText: 'Weiter',
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
