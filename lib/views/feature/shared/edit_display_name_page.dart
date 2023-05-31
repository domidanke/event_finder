import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_icon_button.dart';

class EditDisplayNamePage extends StatefulWidget {
  const EditDisplayNamePage({super.key});

  @override
  State<EditDisplayNamePage> createState() => _EditDisplayNamePageState();
}

class _EditDisplayNamePageState extends State<EditDisplayNamePage> {
  String displayName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const CustomIconButton(),
                    const Spacer(),
                    CustomIconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () async {
                        if (displayName ==
                                StateService().currentUser!.displayName ||
                            displayName.isEmpty) return;
                        await UserDocService().updateDisplayName(displayName);
                        StateService().setCurrentUserDisplayName(displayName);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Name geändert')),
                          );
                          StateService().currentUser!.displayName = displayName;
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              TextField(
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color),
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  displayName = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
