import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:flutter/material.dart';

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
        newEvent.genres = StateService().selectedGenres;
        return true;
      }
      if (currentStep == 2) {
        return true;
      }
      if (currentStep == 3) {
        return newEvent.selectedImageFile != null;
      }
      if (currentStep == 4) {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }
}
