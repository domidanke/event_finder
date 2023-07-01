import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_icon_button.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  List<SupportItem> _supportItems = [];

  @override
  void initState() {
    _supportItems = generateItems(8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CustomIconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: _buildPanel(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      dividerColor: primaryWhite.withOpacity(0.25),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _supportItems[index].isExpanded = !isExpanded;
        });
      },
      children: _supportItems.map<ExpansionPanel>((SupportItem item) {
        return ExpansionPanel(
          backgroundColor: primaryColor.withOpacity(0.25),
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: Container(
            margin: const EdgeInsets.only(bottom: 30),
            child: Text(
              item.expandedValue,
            ),
          ),
          canTapOnHeader: true,
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  List<SupportItem> generateItems(int numberOfItems) {
    return List<SupportItem>.generate(numberOfItems, (int index) {
      return SupportItem(
        headerValue: 'Frage $index',
        expandedValue: 'Dies ist die Antwort zu Frage $index',
      );
    });
  }
}

class SupportItem {
  SupportItem({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
