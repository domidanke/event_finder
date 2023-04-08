import 'package:event_finder/models/onboarding_page_model.dart';

const genres = [
  'techno',
  'rnb',
  'house',
  'rap',
  'pop',
  '90s',
  '80s',
];

const Map<String, String> monthMap = {
  '1': 'Jan',
  '2': 'Feb',
  '3': 'Mär',
  '4': 'Apr',
  '5': 'Mai',
  '6': 'Jun',
  '7': 'Jul',
  '8': 'Aug',
  '9': 'Sep',
  '10': 'Okt',
  '11': 'Nov',
  '12': 'Dez',
};

List<OnboardingPageModel> onboardingPageModels = [
  OnboardingPageModel(
    title: 'Vereint',
    description: 'Events, Hosts, Kuenstler und DICH in einer App!',
    imageUrl: 'page1',
  ),
  OnboardingPageModel(
    title: 'Finde',
    description: 'Events in deiner Naehe!',
    imageUrl: 'page2',
  ),
  OnboardingPageModel(
    title: 'Folge',
    description: 'Hosts und Kuenstlern!',
    imageUrl: 'page3',
  ),
  OnboardingPageModel(
    title: 'Kaufe',
    description: 'Tickets in Lichtgeschwindigkeit!',
    imageUrl: 'page4',
  ),
  OnboardingPageModel(
    title: 'Komm',
    description: 'zum Event und lass es krachen!',
    imageUrl: 'page5',
  ),
  OnboardingPageModel(
    title: 'Event Finder',
    description: 'dein Partybegleiter',
    imageUrl: 'page6',
  ),
];
