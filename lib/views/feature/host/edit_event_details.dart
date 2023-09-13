import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../../services/alert.service.dart';
import '../../../services/firestore/event_doc.service.dart';
import '../../../services/popup.service.dart';
import '../../../widgets/custom_icon_button.dart';

class EditEventDetails extends StatefulWidget {
  const EditEventDetails({super.key});

  @override
  State<EditEventDetails> createState() => _EditEventDetailsState();
}

class _EditEventDetailsState extends State<EditEventDetails> {
  String detailsBeforeEdit = '';
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    detailsBeforeEdit = StateService().lastSelectedEvent!.details;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: primaryGradient),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 42),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 32,
                    )),
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  child: CustomIconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      try {
                        await EventDocService()
                            .updateEventDocument(
                                StateService().lastSelectedEvent!)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              PopupService().getCustomSnackBar(
                                  'Beschreibung aktualisiert'));
                          Navigator.of(context).pop();
                        });
                      } catch (e) {
                        if (mounted) {
                          AlertService().showAlert(
                              'Beschreibung aktualisieren fehlgeschlagen',
                              e.toString(),
                              context);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: 250,
              child: Form(
                key: formKey,
                child: TextFormField(
                  initialValue: StateService().lastSelectedEvent!.details,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte geben Sie eine Beschreibung an';
                    }
                    StateService().setLastSelectedEventDetails = value;
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Beschreibung',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
