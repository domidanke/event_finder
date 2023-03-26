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

  Map<String, Object?> toJson() {
    return {
      'instagram': instagram,
      'facebook': facebook,
      'soundCloud': soundCloud,
    };
  }
}
