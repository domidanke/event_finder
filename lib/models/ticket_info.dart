class TicketInfo {
  final String id;
  final String eventTitle;
  final DateTime eventDate;

  TicketInfo(
      {required this.id, required this.eventTitle, required this.eventDate});

  TicketInfo.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          eventTitle: json['eventTitle']! as String,
          eventDate: DateTime.parse(json['eventDate']! as String),
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'eventTitle': eventTitle,
      'eventDate': eventDate.toString(),
    };
  }
}
