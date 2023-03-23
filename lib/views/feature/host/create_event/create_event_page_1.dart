import 'package:event_finder/models/consts.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/date.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/search_address_in_map.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../models/event.dart';

class CreateEventPage1 extends StatefulWidget {
  const CreateEventPage1({Key? key}) : super(key: key);

  @override
  State<CreateEventPage1> createState() => _CreateEventPage1State();
}

class _CreateEventPage1State extends State<CreateEventPage1> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  late Future<List<Placemark>> _getPlaceMarkers;

  @override
  void initState() {
    StateService().newEvent = NewEvent();
    _getPlaceMarkers = placemarkFromCoordinates(
        AuthService().currentUser!.mainLocationCoordinates.latitude,
        AuthService().currentUser!.mainLocationCoordinates.longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NewEvent newEvent = StateService().newEvent;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
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
                    newEvent.title = value;
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
                      newEvent.date = selectedDate;
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
                    newEvent.details = value;
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
                    newEvent.ticketPrice = int.parse(value);
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: DropdownButton<String>(
                    value: newEvent.genre,
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    onChanged: (String? value) {
                      setState(() {
                        newEvent.genre = value!;
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
                FutureBuilder(
                    future: _getPlaceMarkers,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      final placeMark = snapshot.data!.first;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.location_on),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${placeMark.street}'),
                              Text(
                                  '${placeMark.postalCode} ${placeMark.subAdministrativeArea}'),
                            ],
                          ),
                          KKButton(
                              onPressed: () {
                                _showChangeLocation();
                              },
                              buttonText: 'Andere Location')
                        ],
                      );
                    }),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    KKButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      buttonText: 'Abbrechen',
                    ),
                    KKButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushNamed(context, 'create_event_page_2');
                        }
                      },
                      buttonText: 'Weiter',
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChangeLocation() {
    LatLng? newCoordinates;
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: Column(
                children: [
                  Expanded(
                    child: SearchAddressInMap(onAddressSelected: (coordinates) {
                      newCoordinates = coordinates;
                    }),
                  ),
                  KKButton(
                    onPressed: () {
                      if (newCoordinates == null) return;
                      setState(() {
                        _getPlaceMarkers = placemarkFromCoordinates(
                            newCoordinates!.latitude,
                            newCoordinates!.longitude);
                        StateService().newEvent.locationCoordinates =
                            newCoordinates;
                      });
                      Navigator.pop(context);
                    },
                    buttonText: 'Anwenden',
                  )
                ],
              ));
        });
  }
}
