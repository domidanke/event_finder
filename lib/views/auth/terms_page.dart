import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  final ScrollController _scrollController = ScrollController();
  bool showAcceptButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        showAcceptButton = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Text(
            'Allgemeine Geschäftsbedingungen (AGB)',
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 32.0),
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: const <Widget>[
                Text(
                  '1. Geltungsbereich',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                    'Diese Allgemeinen Geschäftsbedingungen (nachfolgend "AGB") gelten für alle Geschäftsbeziehungen zwischen der Musterfirma GmbH (nachfolgend "Verkäufer") und ihren Kunden (nachfolgend "Kunde").'),
                SizedBox(
                  height: 50,
                ),
                Text(
                  '2. Vertragsabschluss',
                  style: TextStyle(fontSize: 18),
                ),
                Text('2.1 Vertragsangebot'),
                Text(
                    'Die Darstellung der Produkte im Online-Shop oder in anderen Vertriebskanälen des Verkäufers stellt kein rechtlich bindendes Angebot, sondern eine unverbindliche Aufforderung zur Bestellung dar. Durch Anklicken des "Kaufen" Buttons gibt der Kunde eine verbindliche Bestellung der im Warenkorb befindlichen Waren ab.'),
                SizedBox(
                  height: 20,
                ),
                Text('2.2 Vertragsannahme'),
                Text(
                    'Die Bestätigung des Eingangs der Bestellung folgt unmittelbar nach dem Absenden der Bestellung und stellt noch keine Vertragsannahme dar. Der Vertrag kommt erst zustande, wenn der Verkäufer die Bestellung annimmt. Die Annahme erfolgt durch den Versand der bestellten Ware.'),
                SizedBox(
                  height: 50,
                ),
                Text(
                  '3. Preise und Versandkosten',
                  style: TextStyle(fontSize: 18),
                ),
                Text('3.1 Preise'),
                Text(
                    'Die in unserem Online-Shop angegebenen Preise sind Endpreise inklusive der gesetzlichen Mehrwertsteuer.'),
                SizedBox(
                  height: 20,
                ),
                Text('3.2 Versandkosten'),
                Text(
                    'Die Versandkosten sind abhängig von der bestellten Ware und dem Lieferort. Diese werden dem Kunden vor Abschluss der Bestellung angezeigt.'),
                SizedBox(
                  height: 50,
                ),
                Text(
                  '4. Gerichtsstand',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                    'Ausschließlicher Gerichtsstand für alle Streitigkeiten aus diesem Vertrag ist unser Sitz.'),
                SizedBox(
                  height: 50,
                ),
                Text('Nocstar OG'),
                Text('Stuhlstrasse 123'),
                Text('69420 Harthausen'),
                Text('Kontakt: michael.hatnhartn@web.de'),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          if (showAcceptButton)
            CustomButton(
              onPressed: () async {
                await UserDocService().acceptTerms();
                if (mounted) {
                  Navigator.pushNamed(context, '/');
                }
              },
              buttonText: 'Akzeptieren',
            ),
        ],
      ),
    );
  }
}
