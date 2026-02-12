import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/services/api_service.dart';
import '../core/constants.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._apiService);

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String countryCode, String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final formData = FormData.fromMap({
        'country_code': countryCode,
        'phone': phone,
      });

      final response = await _apiService.post(
        AppConstants.otpVerified,
        data: formData,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data['status'] == true) {
        final data = response.data;
        // The token is nested under 'token' -> 'access'
        final token = data['token']?['access'];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(AppConstants.tokenKey, token);
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _error = 'Login failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      if (e is DioException) {
        _error = e.response?.data?['message'] ?? e.message ?? e.toString();
      } else {
        _error = e.toString();
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    notifyListeners();
  }
}
