import 'dart:io';
import 'dart:isolate';

import 'package:bio_pet/models/breed.dart';
import 'package:bio_pet/helper/isolate_inference.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Service responsible for ML classification operations
class ClassificationService {
  late final Interpreter _interpreter;
  late final List<String> _labels;
  late final IsolateInference _isolateInference;
  late Tensor _inputTensor;
  late Tensor _outputTensor;

  static const String _modelPath = 'assets/models/mobilenet_quant.tflite';
  static const String _labelsPath = 'assets/models/labels.txt';

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Initialize the ML model and isolate inference
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _loadLabels();
    await _loadModel();
    _isolateInference = IsolateInference();
    await _isolateInference.start();

    _isInitialized = true;
  }

  /// Load the TFLite model with platform-specific delegates
  Future<void> _loadModel() async {
    final options = InterpreterOptions();

    // Use XNNPACK Delegate for Android
    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    }

    // Use Metal Delegate for iOS
    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    // Load model from assets
    _interpreter = await Interpreter.fromAsset(_modelPath, options: options);

    // Get tensor input shape [1, 224, 224, 3]
    _inputTensor = _interpreter.getInputTensors().first;

    // Get tensor output shape [1, 1001]
    _outputTensor = _interpreter.getOutputTensors().first;
  }

  /// Load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(_labelsPath);
    _labels = labelTxt.split('\n');
  }

  /// Perform inference on an image and return breed classifications
  Future<Map<String, double>> classifyImage(img.Image image) async {
    if (!_isInitialized) {
      throw StateError(
        'ClassificationService not initialized. Call initialize() first.',
      );
    }

    final inferenceModel = InferenceModel(
      image,
      _interpreter.address,
      _labels,
      _inputTensor.shape,
      _outputTensor.shape,
    );

    return _runInference(inferenceModel);
  }

  /// Run inference in isolate
  Future<Map<String, double>> _runInference(
    InferenceModel inferenceModel,
  ) async {
    final responsePort = ReceivePort();
    _isolateInference.sendPort.send(
      inferenceModel..responsePort = responsePort.sendPort,
    );

    // Get inference result
    final results = await responsePort.first;
    return results as Map<String, double>;
  }

  /// Process image file and return sorted breed list
  Future<List<EachBreed>> processImageFile(String imagePath) async {
    // Read image bytes from file
    final imageData = File(imagePath).readAsBytesSync();

    // Decode image using package:image
    final image = img.decodeImage(imageData);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Run classification
    final breedMap = await classifyImage(image);

    // Convert to sorted breed list
    return breedMap.entries
        .map((e) => EachBreed.fromMap(e))
        .where((b) => b.acc > 0)
        .toList()
      ..sort((a, b) => b.acc.compareTo(a.acc));
  }

  /// Clean up resources
  Future<void> dispose() async {
    if (_isInitialized) {
      await _isolateInference.close();
      _isInitialized = false;
    }
  }
}
