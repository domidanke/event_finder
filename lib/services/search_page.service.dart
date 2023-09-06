import 'package:flutter/material.dart';

class SearchPageService extends ChangeNotifier {
  factory SearchPageService() {
    return _singleton;
  }
  SearchPageService._internal();
  static final SearchPageService _singleton = SearchPageService._internal();

  String _searchText = '';
  String get searchText => _searchText;

  set searchText(String text) {
    _searchText = text;
    notifyListeners();
  }
}
