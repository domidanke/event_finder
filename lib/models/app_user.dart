import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/location_data.dart';
import 'package:event_finder/models/ticket_info.dart';

import 'external_links.dart';

class AppUser {
  AppUser({
    this.uid = '',
    required this.displayName,
    required this.type,
    this.savedEvents = const [],
    this.savedArtists = const [],
    this.savedHosts = const [],
    this.follower = const [],
    this.allTickets = const [],
    this.usedTickets = const [],
    this.genres = const [],
    this.externalLinks = const ExternalLinks(),
    this.mainLocation = const LocationData(),
    this.termsAcceptedDate,
  });

  final String uid;
  late String displayName;
  final ExternalLinks externalLinks;
  late UserType type = UserType.base;
  late List<String> savedEvents = [];
  late List<String> savedArtists = [];
  late List<String> savedHosts = [];
  late List<TicketInfo> allTickets = [];
  late List<String> usedTickets = [];
  late List<String> follower = [];
  late List<String> genres = [];
  late LocationData mainLocation;
  String? imageUrl;
  DateTime? termsAcceptedDate;

  AppUser.fromJson(Map<String, Object?> json, String uid)
      : this(
            uid: uid,
            savedArtists: json['savedArtists'] != null
                ? List.from(json['savedArtists'] as List<dynamic>)
                : [],
            savedEvents: json['savedEvents'] != null
                ? List.from(json['savedEvents'] as List<dynamic>)
                : [],
            savedHosts: json['savedHosts'] != null
                ? List.from(json['savedHosts'] as List<dynamic>)
                : [],
            follower: json['follower'] != null
                ? List.from(json['follower'] as List<dynamic>)
                : [],
            genres: json['genres'] != null
                ? List.from(json['genres'] as List<dynamic>)
                : [],
            allTickets: json['allTickets'] != null
                ? List<TicketInfo>.from((json['allTickets'] as List<dynamic>)
                    .map((model) => TicketInfo.fromJson(model)))
                : [],
            usedTickets: json['usedTickets'] != null
                ? List.from(json['usedTickets'] as List<dynamic>)
                : [],
            type: json['type'] != null
                ? UserType.fromString(json['type'] as String)
                : UserType.base,
            externalLinks: json['externalLinks'] != null
                ? ExternalLinks.fromJson(
                    json['externalLinks'] as Map<String, dynamic>)
                : const ExternalLinks(),
            mainLocation: json['mainLocation'] != null
                ? LocationData.fromJson(
                    json['mainLocation'] as Map<String, dynamic>)
                : const LocationData(),
            displayName: json['displayName'] != null
                ? json['displayName'] as String
                : '',
            termsAcceptedDate: json['termsAcceptedDate'] != null
                ? DateTime.parse(
                    (json['termsAcceptedDate'] as Timestamp).toDate().toString())
                : null);

  Map<String, Object?> toJson() {
    return {
      'displayName': displayName,
      'savedEvents': savedEvents,
      'savedArtists': savedArtists,
      'savedHosts': savedHosts,
      'follower': follower,
      'allTickets': allTickets.map((e) => e.toJson()).toList(),
      'usedTickets': usedTickets,
      'genres': genres,
      'externalLinks': externalLinks.toJson(),
      'type': type.name
    };
  }
}
