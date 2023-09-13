import 'dart:io';

import 'package:event_finder/services/state.service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../../../services/create_event.service.dart';
import '../../../../services/image.service.dart';
import '../../../../theme/theme.dart';
import '../../../../widgets/custom_button.dart';
import '../../shared/search_address_in_map.dart';

class CePage4 extends StatefulWidget {
  const CePage4({Key? key}) : super(key: key);

  @override
  State<CePage4> createState() => _CePage4State();
}

class _CePage4State extends State<CePage4> {
  late Future<List<Placemark>> _getPlaceMarkers;

  @override
  void initState() {
    final mainLocation = StateService().currentUser!.mainLocation;
    _getPlaceMarkers = placemarkFromCoordinates(
        mainLocation.geoPoint.latitude, mainLocation.geoPoint.longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
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
                        Text('${placeMark.postalCode} ${placeMark.locality}'),
                      ],
                    ),
                    SizedBox(
                      width: 90,
                      child: CustomButton(
                          onPressed: () {
                            _showLocationBottomSheet();
                          },
                          buttonText: 'Ändern'),
                    )
                  ],
                );
              }),
          const Divider(
            height: 50,
          ),
          if (CreateEventService().newEvent.selectedImageFile == null)
            SizedBox(
              width: 150,
              child: CustomButton(
                  onPressed: _selectImage, buttonText: 'Bild hochladen'),
            ),
          if (CreateEventService().newEvent.selectedImageFile != null)
            Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Image.file(
                        CreateEventService().newEvent.selectedImageFile!)),
                const SizedBox(
                  height: 20,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        CreateEventService().newEvent.selectedImageFile = null;
                      });
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      color: secondaryColor,
                    ))
              ],
            ),
        ],
      ),
    );
  }

  void _showLocationBottomSheet() {
    GeoFirePoint? newCoordinates;
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            gradient: primaryGradient,
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  height: 300,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: SearchAddressInMap(onAddressSelected: (coordinates) {
                    newCoordinates = coordinates;
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 120,
                  child: CustomButton(
                    onPressed: () {
                      if (newCoordinates == null) return;
                      setState(() {
                        _getPlaceMarkers = placemarkFromCoordinates(
                            newCoordinates!.latitude,
                            newCoordinates!.longitude);
                        CreateEventService().newEvent.locationCoordinates =
                            newCoordinates;
                      });
                      Navigator.pop(context);
                    },
                    buttonText: 'Anwenden',
                  ),
                ),
              )
            ],
          )),
    );
  }

  void _selectImage() async {
    final cropped = await ImageService().selectImage();
    if (cropped == null) return;
    setState(() {
      CreateEventService().newEvent.selectedImageFile = File(cropped.path);
    });
  }
}
