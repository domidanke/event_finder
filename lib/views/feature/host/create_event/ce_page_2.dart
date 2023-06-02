import 'package:flutter/material.dart';

import '../../../../services/create_event.service.dart';

class CePage2 extends StatefulWidget {
  const CePage2({Key? key}) : super(key: key);

  @override
  State<CePage2> createState() => _CePage2State();
}

class _CePage2State extends State<CePage2> {
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        child: SizedBox(
          height: 250,
          child: TextFormField(
            onTapOutside: (e) {
              focusNode.unfocus();
            },
            focusNode: focusNode,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              labelText: 'Beschreibung',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte geben Sie eine Beschreibung an';
              }
              CreateEventService().newEvent.details = value;
              return null;
            },
          ),
        ),
      ),
    );
  }
}
