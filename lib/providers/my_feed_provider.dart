import 'package:flutter/material.dart';
import '../data/services/api_service.dart';
import '../data/models/feed_model.dart';
import '../core/constants.dart';

class MyFeedProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<Feed> _myFeeds = [];
  bool _isLoading = false;
  String? _error;

  MyFeedProvider(this._apiService);

  List<Feed> get myFeeds => _myFeeds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMyFeeds() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(AppConstants.myFeed);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        _myFeeds = data.map((json) => Feed.fromJson(json)).toList();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteFeed(int id) async {
    try {
      final response = await _apiService.get(
        '${AppConstants.myFeed}/$id',
      ); // Assuming GET for delete or similar as per typical simplified tasks, usually DELETE
      if (response.statusCode == 200) {
        _myFeeds.removeWhere((feed) => feed.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
