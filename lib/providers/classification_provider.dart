import 'package:bio_pet/models/breed.dart';
import 'package:bio_pet/services/classification_service.dart';
import 'package:bio_pet/services/history_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Provider for managing classification state and operations
class ClassificationProvider extends ChangeNotifier {
  final ClassificationService _classificationService;
  final HistoryService _historyService;
  final ImagePicker _imagePicker = ImagePicker();

  ClassificationProvider({
    required ClassificationService classificationService,
    required HistoryService historyService,
  }) : _classificationService = classificationService,
       _historyService = historyService;

  // State
  bool _isLoading = false;
  String? _imagePath;
  List<EachBreed> _breedList = [];
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get imagePath => _imagePath;
  List<EachBreed> get breedList => _breedList;
  String? get errorMessage => _errorMessage;
  bool get hasResult => _breedList.isNotEmpty;

  /// Initialize the classification service
  Future<void> initialize() async {
    try {
      _setLoading(true);
      await _classificationService.initialize();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize: $e');
      _setLoading(false);
    }
  }

  /// Pick an image from the specified source
  Future<void> pickImage(ImageSource source) async {
    try {
      _clearError();
      final result = await _imagePicker.pickImage(source: source);

      if (result != null) {
        _imagePath = result.path;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to pick image: $e');
    }
  }

  /// Process the selected image and classify it
  Future<void> classifyImage() async {
    if (_imagePath == null) {
      _setError('No image selected');
      return;
    }

    try {
      _setLoading(true);
      _clearError();

      // Perform classification
      _breedList = await _classificationService.processImageFile(_imagePath!);

      // Save to history
      if (_breedList.isNotEmpty) {
        await _historyService.saveClassification(
          imagePath: _imagePath!,
          breeds: _breedList,
        );
      }

      _setLoading(false);
    } catch (e) {
      _setError('Classification failed: $e');
      _setLoading(false);
    }
  }

  /// Clear current classification results
  void clearResults() {
    _imagePath = null;
    _breedList = [];
    _errorMessage = null;
    notifyListeners();
  }

  // Private helpers
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    _classificationService.dispose();
    super.dispose();
  }
}
