import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/location_data.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class Event {
  Event(
      {this.uid = '',
      required this.title,
      required this.details,
      required this.startDate,
      required this.endDate,
      required this.genres,
      required this.ticketPrice,
      required this.maxTickets,
      required this.creatorId,
      required this.creatorName,
      this.artists = const [],
      this.soldTickets = const [],
      this.scannedTickets = const [],
      this.location = const LocationData()});

  Event.fromJson(Map<String, Object?> json, String uid)
      : this(
          uid: uid,
          title: json['title']! as String,
          details: json['details']! as String,
          startDate: DateTime.parse(
              (json['startDate']! as Timestamp).toDate().toString()),
          endDate: json['endDate'] != null
              ? DateTime.parse(
                  (json['endDate']! as Timestamp).toDate().toString())
              : null,
          genres: json['genres'] != null
              ? List.from(json['genres']! as List<dynamic>)
              : [],
          ticketPrice: json['ticketPrice']! as int,
          maxTickets:
              json['maxTickets'] != null ? json['maxTickets']! as int : 0,
          creatorId: json['creatorId']! as String,
          creatorName: json['creatorName']! as String,
          artists: json['artists'] != null
              ? List.from(json['artists'] as List<dynamic>)
              : [],
          soldTickets: json['soldTickets'] != null
              ? List.from(json['soldTickets'] as List<dynamic>)
              : [],
          scannedTickets: json['scannedTickets'] != null
              ? List.from(json['scannedTickets'] as List<dynamic>)
              : [],
          location: json['location'] != null
              ? LocationData.fromJson(json['location'] as Map<String, dynamic>)
              : const LocationData(),
        );

  final String uid;
  final String title;
  late String details;
  final List<String> genres;
  final int ticketPrice;
  final int maxTickets;
  final DateTime startDate;
  final DateTime? endDate;
  final String creatorId;
  final String creatorName;
  final LocationData location;
  late List<String> artists = [];
  late List<String> soldTickets = [];
  late List<String> scannedTickets = [];
  String? imageUrl;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'details': details,
      'startDate': startDate,
      'endDate': endDate,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'artists': artists,
      'soldTickets': soldTickets,
      'scannedTickets': scannedTickets,
      'genres': genres,
      'ticketPrice': ticketPrice,
      'maxTickets': maxTickets,
      'location': location.toJson(),
    };
  }
}

class NewEvent {
  NewEvent();
  String title = '';
  String details = '';
  List<String> genres = [];
  int ticketPrice = 0;
  int maxTickets = 0;
  DateTime? startDate;
  DateTime? endDate;
  File? selectedImageFile;
  List<String> enlistedArtists = [];
  GeoFirePoint? locationCoordinates;

  Event toEvent() {
    return Event(
        title: title,
        details: details,
        startDate: startDate!,
        endDate: endDate,
        genres: genres,
        creatorId: StateService().currentUser!.uid,
        creatorName: StateService().currentUser!.displayName,
        ticketPrice: ticketPrice,
        maxTickets: maxTickets,
        artists: enlistedArtists,
        location: locationCoordinates != null
            ? LocationData.fromJson(locationCoordinates!.data)
            : StateService().currentUser!.mainLocation);
  }
}
