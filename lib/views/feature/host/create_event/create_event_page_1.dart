import 'package:event_finder/models/consts.dart';
import 'package:event_finder/services/date.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateEventPage1 extends StatefulWidget {
  const CreateEventPage1({Key? key}) : super(key: key);

  @override
  State<CreateEventPage1> createState() => _CreateEventPage1State();
}

class _CreateEventPage1State extends State<CreateEventPage1> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String details;
  late int ticketPrice;
  late String address;
  TextEditingController dateController = TextEditingController();
  DateTime? _selectedDate;

  String selectedGenre = genres.first;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            TextFormField(
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
              decoration: const InputDecoration(
                labelText: 'Titel',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                title = value;
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
              controller: dateController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Datum',
              ),
              onTap: () async {
                final selectedDate =
                    await DateService().showIosDatePicker(context);
                setState(() {
                  dateController.text =
                      selectedDate.toString().substring(0, 16);
                  _selectedDate = selectedDate;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
              decoration: const InputDecoration(
                labelText: 'Beschreibung',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                details = value;
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
              decoration: const InputDecoration(
                labelText: 'Ticket Preis',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                ticketPrice = int.parse(value);
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: DropdownButton<String>(
                value: selectedGenre,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                onChanged: (String? value) {
                  setState(() {
                    selectedGenre = value!;
                  });
                },
                items: genres.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
