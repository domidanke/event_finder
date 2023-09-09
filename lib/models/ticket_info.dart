import 'package:cloud_firestore/cloud_firestore.dart';

class TicketInfo {
  final List<String> ticketQrCodeIds;
  final String userId;
  final String eventId;
  final String creatorId;
  final String creatorName;
  final String eventTitle;
  final DateTime startDate;
  final DateTime? endDate;
  final int ticketPrice;
  String? imageUrl;

  TicketInfo({
    required this.ticketQrCodeIds,
    required this.userId,
    required this.eventId,
    required this.creatorId,
    required this.creatorName,
    required this.eventTitle,
    required this.startDate,
    required this.endDate,
    required this.ticketPrice,
  });

  TicketInfo.fromJson(Map<String, Object?> json)
      : this(
          ticketQrCodeIds: List.from(json['ticketQrCodeIds']! as List<dynamic>),
          userId: json['userId']! as String,
          eventId: json['eventId']! as String,
          creatorId: json['creatorId']! as String,
          creatorName: json['creatorName']! as String,
          eventTitle: json['eventTitle']! as String,
          startDate: DateTime.parse(
              (json['startDate']! as Timestamp).toDate().toString()),
          endDate: json['endDate'] != null
              ? DateTime.parse(
                  (json['endDate']! as Timestamp).toDate().toString())
              : null,
          ticketPrice: json['ticketPrice']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'ticketQrCodeIds': ticketQrCodeIds,
      'userId': userId,
      'eventId': eventId,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'eventTitle': eventTitle,
      'startDate': startDate,
      'endDate': endDate,
      'ticketPrice': ticketPrice
    };
  }
}
