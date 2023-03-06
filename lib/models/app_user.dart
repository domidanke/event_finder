import 'package:event_finder/models/enums.dart';

class AppUser {
  AppUser({
    required this.type,
    this.savedEvents = const [],
    this.savedArtists = const [],
  });

  late UserType type;
  late List<String> savedEvents = [];
  late List<String> savedArtists = [];

  AppUser.fromJson(Map<String, dynamic> json) {
    savedArtists = List.from(json['savedArtists']);
    savedEvents = List.from(json['savedEvents']);
    type = UserType.fromJson(json['type']);
  }

  Map<String, Object?> toJson() {
    return {
      'savedEvents': savedEvents,
      'savedArtists': savedArtists,
      'type': type.name
    };
  }
}
