import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/popup.service.dart';
import 'package:event_finder/services/search_page.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:flutter/material.dart';

import 'alert.service.dart';
import 'firestore/event_doc.service.dart';

class CreateEventService extends ChangeNotifier {
  factory CreateEventService() {
    return _singleton;
  }
  CreateEventService._internal();
  static final CreateEventService _singleton = CreateEventService._internal();

  NewEvent newEvent = NewEvent();
  final formKey = GlobalKey<FormState>();
  int currentStep = 1;

  bool _isCreating = false;

  bool get isCreating => _isCreating;

  set isCreating(bool isCreating) {
    _isCreating = isCreating;
    notifyListeners();
  }

  bool validateStep() {
    if (formKey.currentState!.validate()) {
      if (currentStep == 1) {
        return true;
      }
      if (currentStep == 2) {
        if (StateService().selectedGenres.isEmpty) return false;
        newEvent.genres = StateService().selectedGenres;
        return true;
      }
      if (currentStep == 3) {
        return true;
      }
      if (currentStep == 4) {
        if (newEvent.selectedImageFile != null) {
          SearchService().searchText = '';
          return true;
        } else {
          return false;
        }
      }
      if (currentStep == 5) {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  Future<void> createEvent(BuildContext context) async {
    CreateEventService().isCreating = true;
    final event = CreateEventService().newEvent.toEvent();
    final eventId = await EventDocService().addEventDocument(event);
    StateService().resetSelectedGenres();
    await StorageService()
        .saveEventImageToStorage(
            eventId, CreateEventService().newEvent.selectedImageFile!)
        .then((value) => {
              CreateEventService().isCreating = false,
              ScaffoldMessenger.of(context).showSnackBar(
                  PopupService().getCustomSnackBar('Event erstellt')),
              Navigator.popUntil(context, ModalRoute.withName('/')),
              Navigator.pushNamed(context, 'current_events'),
            })
        .catchError((e) {
      AlertService().showAlert(
          'Event Bild hochladen fehlgeschlagen', e.toString(), context);
    });
  }
}
