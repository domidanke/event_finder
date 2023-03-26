import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/ticket_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    this.externalLinks = const ExternalLinks(),
    this.mainLocationCoordinates = const LatLng(0, 0),
  });

  final String uid;
  final String displayName;
  final ExternalLinks externalLinks;
  late UserType type = UserType.base;
  late List<String> savedEvents = [];
  late List<String> savedArtists = [];
  late List<String> savedHosts = [];
  late List<TicketInfo> allTickets = [];
  late List<String> usedTickets = [];
  late List<String> follower = [];
  late LatLng mainLocationCoordinates;
  String? imageUrl;

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
            mainLocationCoordinates: json['mainLocationCoordinates'] != null
                ? LatLng((json['mainLocationCoordinates'] as List<dynamic>)[0],
                    (json['mainLocationCoordinates'] as List<dynamic>)[1])
                : const LatLng(0, 0),
            displayName: json['displayName'] != null
                ? json['displayName'] as String
                : '');

  Map<String, Object?> toJson() {
    return {
      'displayName': displayName,
      'savedEvents': savedEvents,
      'savedArtists': savedArtists,
      'savedHosts': savedHosts,
      'follower': follower,
      'allTickets': allTickets.map((e) => e.toJson()).toList(),
      'usedTickets': usedTickets,
      'externalLinks': externalLinks.toJson(),
      'mainLocationCoordinates': mainLocationCoordinates.toJson(),
      'type': type.name
    };
  }
}
