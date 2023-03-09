class Event {
  Event(
      {this.uid = '',
      required this.title,
      required this.details,
      required this.date,
      required this.address,
      required this.genre,
      required this.ticketPrice,
      required this.creatorId,
      required this.creatorName});

  Event.fromJson(Map<String, Object?> json, String uid)
      : this(
          uid: uid,
          title: json['title']! as String,
          details: json['details']! as String,
          date: DateTime.parse(json['date']! as String),
          address: json['address']! as String,
          genre: json['genre']! as String,
          ticketPrice: json['ticketPrice']! as int,
          creatorId: json['creatorId']! as String,
          creatorName: json['creatorName']! as String,
        );

  final String uid;
  final String title;
  final String details;
  final String address;
  final String genre;
  final int ticketPrice;
  final DateTime date;
  final String creatorId;
  final String creatorName;
  String? imageUrl;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'details': details,
      'date': date.toString(),
      'creatorId': creatorId,
      'creatorName': creatorName,
      'address': address,
      'genre': genre,
      'ticketPrice': ticketPrice,
    };
  }
}
