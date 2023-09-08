import 'package:event_finder/services/create_event.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/host/create_event/ce_page_1.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:event_finder/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/event.dart';
import '../../../../services/alert.service.dart';
import '../../../../services/firestore/event_doc.service.dart';
import '../../../../services/storage/storage.service.dart';
import 'ce_page_2.dart';
import 'ce_page_3.dart';
import 'ce_page_4.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final PageController pageController = PageController();

  @override
  void initState() {
    StateService().resetSelectedGenres();
    CreateEventService().newEvent = NewEvent();
    super.initState();
  }

  @override
  void dispose() {
    StateService().resetSelectedGenres();
    CreateEventService().currentStep = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = CreateEventService().currentStep;
    final bool isCreating = Provider.of<CreateEventService>(context).isCreating;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            if (isCreating)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Event wird erstellt'),
                    SizedBox(
                      height: 16,
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            Opacity(
              opacity: isCreating ? 0.2 : 1,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12.0),
                        child: const Text(
                          'Neues Event',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ProgressBar(
                          currentStep: currentStep,
                          totalSteps: 4,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Form(
                        key: CreateEventService().formKey,
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: pageController,
                          children: const <Widget>[
                            CePage1(),
                            CePage2(),
                            CePage3(),
                            CePage4()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      KKButton(
                        onPressed: () {
                          if (currentStep == 1) {
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              CreateEventService().currentStep--;
                              _goToPage();
                            });
                          }
                        },
                        buttonText: currentStep == 1 ? 'Abbrechen' : 'Zurück',
                      ),
                      KKButton(
                        onPressed: () {
                          if (isCreating) return;
                          if (CreateEventService().validateStep()) {
                            if (currentStep == 4) {
                              _createEvent();
                            } else {
                              setState(() {
                                CreateEventService().currentStep++;
                                _goToPage();
                              });
                            }
                          }
                        },
                        buttonText: currentStep == 4 ? 'Erstellen' : 'Weiter',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToPage() {
    pageController.animateToPage(CreateEventService().currentStep - 1,
        duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }

  Future<void> _createEvent() async {
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
                SnackBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.check_circle_outline,
                          color: primaryWhite,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Text(
                          'Event erstellt.',
                          style: TextStyle(color: primaryWhite),
                        ),
                      ],
                    ),
                    backgroundColor: primaryColor),
              ),
              Navigator.popUntil(context, ModalRoute.withName('/')),
              Navigator.pushNamed(context, 'current_events'),
            })
        .catchError((e) {
      AlertService().showAlert(
          'Event Bild hochladen fehlgeschlagen', e.toString(), context);
    });
  }
}
