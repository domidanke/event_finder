class Event {
  Event({required this.title, required this.text, required this.date, required this.createdBy});

  Event.fromJson(Map<String, Object?> json)
      : this(
    title: json['title']! as String,
    text: json['text']! as String,
    date: DateTime.parse(json['date']! as String),
    createdBy: json['createdBy']! as String,
  );

  final String title;
  final String text;
  final DateTime date;
  final String createdBy;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'text': text,
      'date': date.toString(),
      'createdBy': createdBy
    };
  }
}
