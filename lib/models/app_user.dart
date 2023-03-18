import 'package:event_finder/models/enums.dart';

class AppUser {
  AppUser({
    this.uid = '',
    required this.displayName,
    required this.type,
    this.savedEvents = const [],
    this.savedArtists = const [],
    this.savedHosts = const [],
    this.follower = const [],
    this.externalLinks = const ExternalLinks(),
  });

  final String uid;
  final String displayName;
  final ExternalLinks externalLinks;
  late UserType type = UserType.base;
  late List<String> savedEvents = [];
  late List<String> savedArtists = [];
  late List<String> savedHosts = [];
  late List<String> follower = [];
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
            type: json['type'] != null
                ? UserType.fromString(json['type'] as String)
                : UserType.base,
            externalLinks: json['externalLinks'] != null
                ? ExternalLinks.fromJson(
                    json['externalLinks'] as Map<String, dynamic>)
                : const ExternalLinks(),
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
      'externalLinks': externalLinks,
      'type': type.name
    };
  }
}

class ExternalLinks {
  const ExternalLinks({
    this.instagram = '',
    this.facebook = '',
    this.soundCloud = '',
  });

  final String instagram;
  final String facebook;
  final String soundCloud;

  ExternalLinks.fromJson(Map<String, Object?> json)
      : this(
            instagram: json['instagram'] as String,
            facebook: json['facebook'] as String,
            soundCloud: json['soundCloud'] as String);
}
