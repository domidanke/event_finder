import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/kk_button.dart';

class CreateEventPage2 extends StatefulWidget {
  const CreateEventPage2({Key? key}) : super(key: key);

  @override
  State<CreateEventPage2> createState() => _CreateEventPage2State();
}

class _CreateEventPage2State extends State<CreateEventPage2> {
  final focusNode = FocusNode();
  final _detailsFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    NewEvent newEvent = StateService().newEvent;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Form(
              key: _detailsFormKey,
              child: Column(
                children: [
                  TextFormField(
                    onTapOutside: (e) {
                      focusNode.unfocus();
                    },
                    focusNode: focusNode,
                    maxLines: 15,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: 'Beschreibung',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      newEvent.details = value;
                      return null;
                    },
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      KKButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        buttonText: 'Zurück',
                      ),
                      KKButton(
                        onPressed: () {
                          if (_detailsFormKey.currentState!.validate() &&
                              newEvent.details.isNotEmpty) {
                            Navigator.pushNamed(context, 'create_event_page_3');
                          }
                        },
                        buttonText: 'Weiter',
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
