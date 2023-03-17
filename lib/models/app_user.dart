import 'package:event_finder/models/enums.dart';

class AppUser {
  AppUser({
    required this.displayName,
    required this.type,
    this.savedEvents = const [],
    this.savedArtists = const [],
    this.externalLinks = const ExternalLinks(),
  });

  final String displayName;
  final ExternalLinks externalLinks;
  late UserType type = UserType.base;
  late List<String> savedEvents = [];
  late List<String> savedArtists = [];

  AppUser.fromJson(Map<String, Object?> json)
      : this(
            savedArtists: List.from(json['savedArtists'] as List<dynamic>),
            savedEvents: List.from(json['savedEvents'] as List<dynamic>),
            type: UserType.fromString(json['type'] as String),
            externalLinks: ExternalLinks.fromJson(
                json['externalLinks'] as Map<String, dynamic>),
            displayName: json['displayName'] != null
                ? json['displayName'] as String
                : '');

  Map<String, Object?> toJson() {
    return {
      'savedEvents': savedEvents,
      'savedArtists': savedArtists,
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
