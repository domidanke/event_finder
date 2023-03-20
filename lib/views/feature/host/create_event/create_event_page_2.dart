import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widgets/kk_button.dart';

class CreateEventPage2 extends StatefulWidget {
  const CreateEventPage2({Key? key}) : super(key: key);

  @override
  State<CreateEventPage2> createState() => _CreateEventPage2State();
}

class _CreateEventPage2State extends State<CreateEventPage2> {
  File? selectedImageFile;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              KKButton(
                  onPressed: () async {
                    final XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (image == null) return;
                    setState(() {
                      selectedImageFile = File(image.path);
                    });
                  },
                  buttonText: 'Bild hochladen'),
              SizedBox(
                width: 100,
                child: Text(
                  selectedImageFile != null ? 'Image ready' : '',
                  style: const TextStyle(color: Colors.greenAccent),
                ),
              ),
            ],
          ),
        ));
  }
}
