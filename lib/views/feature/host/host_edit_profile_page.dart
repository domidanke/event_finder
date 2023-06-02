import 'dart:io';

import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/custom_icon_button.dart';

class HostEditProfilePage extends StatefulWidget {
  const HostEditProfilePage({Key? key}) : super(key: key);

  @override
  State<HostEditProfilePage> createState() => _HostEditProfilePageState();
}

class _HostEditProfilePageState extends State<HostEditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  CustomIconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Anderer Name'),
                      onTap: () {
                        Navigator.pushNamed(context, 'edit_display_name');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Andere Location'),
                      onTap: () {
                        Navigator.pushNamed(context, 'set_main_location');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.password),
                      title: const Text('Anderes Passwort'),
                      onTap: () {
                        print('Change Password');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.image),
                      title: const Text('Anderes Profilbild'),
                      onTap: () async {
                        final XFile? image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image == null) return;
                        await StorageService()
                            .saveProfileImageToStorage(File(image.path));
                        await StateService().refreshCurrentUserImageUrl();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Profilbild geaendert')),
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
