import 'package:event_finder/services/create_event.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/host/create_event/ce_page_1.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:event_finder/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

import '../../../../models/event.dart';
import '../../../../services/alert.service.dart';
import '../../../../services/firestore/event_doc.service.dart';
import '../../../../services/firestore/event_ticket_doc.service.dart';
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
    print('WRAPPER');
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
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
                    'Neue Veranstaltung',
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
    );
  }

  void _goToPage() {
    pageController.animateToPage(CreateEventService().currentStep - 1,
        duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }

  Future<void> _createEvent() async {
    final event = CreateEventService().newEvent.toEvent();
    final eventId = await EventDocService().addEventDocument(event);
    StateService().resetSelectedGenres();
    await EventTicketDocService().addTicketDocument(eventId);
    await StorageService()
        .saveEventImageToStorage(
            eventId, CreateEventService().newEvent.selectedImageFile!)
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event erstellt.')),
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
