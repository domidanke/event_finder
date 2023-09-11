import 'package:flutter/material.dart';

class SearchService extends ChangeNotifier {
  factory SearchService() {
    return _singleton;
  }
  SearchService._internal();
  static final SearchService _singleton = SearchService._internal();

  String _searchText = '';
  String get searchText => _searchText;

  set searchText(String text) {
    _searchText = text;
    notifyListeners();
  }
}
