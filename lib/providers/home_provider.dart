import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/services/api_service.dart';
import '../data/models/category_model.dart';
import '../data/models/feed_model.dart';
import '../core/constants.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<Category> _categories = [];
  List<Feed> _feeds = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedCategoryId;

  int? _activeVideoIndex;

  HomeProvider(this._apiService);

  List<Category> get categories => _categories;
  List<Feed> get feeds => _feeds;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get activeVideoIndex => _activeVideoIndex;
  String? get selectedCategoryId => _selectedCategoryId;

  void selectCategory(String? id) {
    if (_selectedCategoryId == id) return;
    _selectedCategoryId = id;
    _feeds = []; // Clear current feeds
    _activeVideoIndex = null;
    notifyListeners();
    fetchFeeds();
  }

  void setActiveVideo(int? index) {
    _activeVideoIndex = index;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(AppConstants.categoryList);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 202) {
        final data = response.data;
        final List<dynamic> catData =
            data['categories'] ?? (data['results'] ?? data);
        _categories = catData.map((json) => Category.fromJson(json)).toList();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFeeds() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> queryParams = {};
      if (_selectedCategoryId != null) {
        queryParams['category_id'] = _selectedCategoryId;
      }

      final response = await _apiService.get(
        AppConstants.home,
        queryParameters: queryParams,
      );
      if (response.statusCode == 200 || response.data['status'] == true) {
        final data = response.data;

        // Handle category_dict if present in home response
        if (data['category_dict'] != null) {
          final List<dynamic> catData = data['category_dict'];
          _categories = catData.map((json) => Category.fromJson(json)).toList();
        }

        // Handle results
        if (data['results'] != null) {
          final List<dynamic> feedData = data['results'];
          _feeds = feedData.map((json) => Feed.fromJson(json)).toList();
        } else if (data is List) {
          _feeds = data.map((json) => Feed.fromJson(json)).toList();
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
