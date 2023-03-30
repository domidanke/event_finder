import 'dart:io';

import 'package:event_finder/models/location_data.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import 'consts.dart';

class Event {
  Event(
      {this.uid = '',
      required this.title,
      required this.details,
      required this.date,
      required this.genre,
      required this.ticketPrice,
      required this.creatorId,
      required this.creatorName,
      this.artists = const [],
      this.location = const LocationData()});

  Event.fromJson(Map<String, Object?> json, String uid)
      : this(
          uid: uid,
          title: json['title']! as String,
          details: json['details']! as String,
          date: DateTime.parse(json['date']! as String),
          genre: json['genre']! as String,
          ticketPrice: json['ticketPrice']! as int,
          creatorId: json['creatorId']! as String,
          creatorName: json['creatorName']! as String,
          artists: json['artists'] != null
              ? List.from(json['artists'] as List<dynamic>)
              : [],
          location: json['location'] != null
              ? LocationData.fromJson(json['location'] as Map<String, dynamic>)
              : const LocationData(),
        );

  final String uid;
  final String title;
  late String details;
  final String genre;
  final int ticketPrice;
  final DateTime date;
  final String creatorId;
  final String creatorName;
  final LocationData location;
  late List<String> artists = [];
  String? imageUrl;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'details': details,
      'date': date.toString(),
      'creatorId': creatorId,
      'creatorName': creatorName,
      'artists': artists,
      'genre': genre,
      'ticketPrice': ticketPrice,
      'location': location.toJson(),
    };
  }
}

class NewEvent {
  NewEvent();

  String title = '';
  String details = '';
  String genre = genres.first;
  int ticketPrice = 0;
  DateTime date = DateTime.now();
  File? selectedImageFile;
  List<String> enlistedArtists = [];
  GeoFirePoint? locationCoordinates;

  Event toEvent() {
    return Event(
        title: title,
        details: details,
        date: date,
        genre: genre,
        creatorId: AuthService().getCurrentFirebaseUser()!.uid,
        creatorName: AuthService().getCurrentFirebaseUser()!.displayName ?? '',
        ticketPrice: ticketPrice,
        artists: enlistedArtists,
        location: locationCoordinates != null
            ? locationCoordinates!.data as LocationData
            : StateService().currentUser!.mainLocation);
  }
}
