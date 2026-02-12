import 'package:flutter/material.dart';
import '../data/services/api_service.dart';
import '../data/models/feed_model.dart';
import '../core/constants.dart';

class MyFeedProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<Feed> _myFeeds = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;

  MyFeedProvider(this._apiService);

  List<Feed> get myFeeds => _myFeeds;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> fetchMyFeeds({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasMore = true;
      _myFeeds = [];
    }

    if (!_hasMore || (_isLoading || _isLoadingMore)) return;

    if (_currentPage == 1) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(
        AppConstants.myFeed,
        queryParameters: {'page': _currentPage},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? [];
        final List<Feed> newFeeds = data
            .map((json) => Feed.fromJson(json))
            .toList();

        if (isRefresh) {
          _myFeeds = newFeeds;
        } else {
          _myFeeds.addAll(newFeeds);
        }

        _hasMore = response.data['next'] != null;
        if (_hasMore) {
          _currentPage++;
        }
      }

      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _isLoadingMore = false;
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
