class EventTicket {
  final List<String> allTickets;
  final List<String> usedTickets;

  EventTicket({required this.allTickets, required this.usedTickets});

  EventTicket.fromJson(Map<String, Object?> json)
      : this(
          allTickets: json['allTickets'] != null
              ? List.from(json['allTickets'] as List<dynamic>)
              : [],
          usedTickets: json['usedTickets'] != null
              ? List.from(json['usedTickets'] as List<dynamic>)
              : [],
        );

  Map<String, Object?> toJson() {
    return {
      'allTickets': allTickets,
      'usedTickets': usedTickets,
    };
  }
}
