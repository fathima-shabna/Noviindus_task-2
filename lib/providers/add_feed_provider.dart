import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../data/services/api_service.dart';
import '../core/constants.dart';

class AddFeedProvider extends ChangeNotifier {
  final ApiService _apiService;
  final ImagePicker _picker = ImagePicker();

  File? _videoFile;
  File? _imageFile;
  String _description = '';
  List<String> _selectedCategories = [];

  bool _isLoading = false;
  double _uploadProgress = 0;
  String? _error;

  AddFeedProvider(this._apiService);

  File? get videoFile => _videoFile;
  File? get imageFile => _imageFile;
  bool get isLoading => _isLoading;
  double get uploadProgress => _uploadProgress;
  String? get error => _error;
  List<String> get selectedCategories => _selectedCategories;

  void setDescription(String desc) {
    _description = desc;
    notifyListeners();
  }

  void toggleCategory(String id) {
    if (_selectedCategories.contains(id)) {
      _selectedCategories.remove(id);
    } else {
      _selectedCategories.add(id);
    }
    notifyListeners();
  }

  Future<void> pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      // Validate video: MP4 and < 5 mins
      if (!video.path.toLowerCase().endsWith('.mp4')) {
        _error = 'Only MP4 videos are allowed.';
        notifyListeners();
        return;
      }

      final controller = VideoPlayerController.file(File(video.path));
      await controller.initialize();
      final duration = controller.value.duration;
      await controller.dispose();

      if (duration.inMinutes >= 5) {
        _error = 'Video must be less than 5 minutes.';
        notifyListeners();
        return;
      }

      _videoFile = File(video.path);
      _error = null;
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imageFile = File(image.path);
      notifyListeners();
    }
  }

  Future<bool> uploadFeed() async {
    if (_videoFile == null ||
        _imageFile == null ||
        _description.isEmpty ||
        _selectedCategories.isEmpty) {
      _error = 'All fields are mandatory.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _uploadProgress = 0;
    _error = null;
    notifyListeners();

    try {
      // API expects categories as a list in multipart form
      final formData = FormData.fromMap({
        'video': await MultipartFile.fromFile(
          _videoFile!.path,
          filename: 'video.mp4',
        ),
        'image': await MultipartFile.fromFile(
          _imageFile!.path,
          filename: 'image.jpg',
        ),
        'desc': _description,
      });

      // Add categories properly as multiple 'category' fields
      for (var catId in _selectedCategories) {
        formData.fields.add(MapEntry('category', catId));
      }

      final response = await _apiService.post(
        AppConstants.myFeed,
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0) {
            _uploadProgress = sent / total;
            notifyListeners();
          }
        },
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data['status'] == true) {
        reset();
        return true;
      } else {
        _error = response.data['message'] ?? 'Upload failed.';
        return false;
      }
    } catch (e) {
      if (e is DioException) {
        _error = e.response?.data?['message'] ?? e.message;
      } else {
        _error = e.toString();
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _videoFile = null;
    _imageFile = null;
    _description = '';
    _selectedCategories = [];
    _isLoading = false;
    _uploadProgress = 0;
    _error = null;
    notifyListeners();
  }
}
