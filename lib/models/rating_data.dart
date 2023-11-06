class RatingData {
  const RatingData({
    required this.totalRating,
    required this.numOfRatings,
  });

  final int totalRating;
  final int numOfRatings;

  RatingData.fromJson(Map<String, Object?> json)
      : this(
            totalRating: json['totalRating'] as int,
            numOfRatings: json['numOfRatings'] as int);

  toJson() {
    return {'totalRating': totalRating, 'numOfRatings': numOfRatings};
  }
}
