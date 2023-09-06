import 'package:event_finder/models/onboarding_page_model.dart';
import 'package:event_finder/models/top_genre.dart';
import 'package:flutter/material.dart';

const genres = [
  'techno',
  'rnb',
  'house',
  'rap',
  'pop',
  '90s',
  '80s',
  'indie',
  'folk',
  'rock',
  'alternative',
  'heavy',
  'lofi',
  '2000s',
  'jazz',
  'country',
  'hispanic',
  'spanish',
  'electro',
];

List<TopGenre> topGenres = [
  TopGenre(
      name: 'techno',
      color: Colors.redAccent,
      imagePath: 'assets/images/onboarding/page1.png'),
  TopGenre(
      name: 'rnb',
      color: Colors.blueAccent,
      imagePath: 'assets/images/onboarding/page2.png'),
  TopGenre(
      name: 'house',
      color: Colors.green,
      imagePath: 'assets/images/onboarding/page3.png'),
  TopGenre(
      name: 'rap',
      color: Colors.purple,
      imagePath: 'assets/images/onboarding/page4.png'),
  TopGenre(
      name: 'pop',
      color: Colors.orange,
      imagePath: 'assets/images/onboarding/page5.png'),
  TopGenre(
      name: '90s',
      color: Colors.teal,
      imagePath: 'assets/images/onboarding/page6.png'),
];

const Map<int, String> monthMap = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mär',
  4: 'Apr',
  5: 'Mai',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Okt',
  11: 'Nov',
  12: 'Dez',
};

const Map<int, String> weekdayMap = {
  1: 'Mon',
  2: 'Die',
  3: 'Mit',
  4: 'Don',
  5: 'Fre',
  6: 'Sam',
  7: 'Son',
};

List<OnboardingPageModel> onboardingPageModels = [
  OnboardingPageModel(
    title: 'Vereint',
    description: 'Events, Hosts, Künstler und DICH in einer App!',
    imageUrl: 'page1',
  ),
  OnboardingPageModel(
    title: 'Finde',
    description: 'Events in deiner Nähe!',
    imageUrl: 'page2',
  ),
  OnboardingPageModel(
    title: 'Folge',
    description: 'Hosts und Künstlern!',
    imageUrl: 'page3',
  ),
  OnboardingPageModel(
    title: 'Kaufe',
    description: 'Tickets in Lichtgeschwindigkeit!',
    imageUrl: 'page4',
  ),
  OnboardingPageModel(
    title: 'Komm',
    description: 'zu Events und lass es krachen!',
    imageUrl: 'page5',
  ),
  OnboardingPageModel(
    title: 'Nocstar',
    description: 'dein Partybegleiter',
    imageUrl: 'page6',
  ),
];

const dialogPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 24);
