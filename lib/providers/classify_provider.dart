import 'dart:io';
import 'dart:isolate';

// import 'package:camera/camera.dart';
import 'package:bio_pet/models/breed.dart';
import 'package:bio_pet/models/history.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:bio_pet/helper/isolate_inference.dart';
import 'package:flutter/material.dart';
import 'package:bio_pet/utils/local_storage.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ClassifyProvider extends ChangeNotifier {
  bool isLoading = false;
  String? imagePath;
  img.Image? image;
  Map<String, double>? breedMap;
  final imagePicker = ImagePicker();
  String breedName = "";
  // int confidence = 10;
  List<EachBreed> breedList = [];
  // int totalConfidence = 0;
  static const modelPath = 'assets/models/mobilenet_quant.tflite';
  static const labelsPath = 'assets/models/labels.txt';

  late final Interpreter interpreter;
  late final List<String> labels;
  late final IsolateInference isolateInference;
  late Tensor inputTensor;
  late Tensor outputTensor;

  // Load model
  Future<void> _loadModel() async {
    final options = InterpreterOptions();

    // Use XNNPACK Delegate
    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    }

    // Use GPU Delegate
    // doesn't work on emulator
    // if (Platform.isAndroid) {
    //   options.addDelegate(GpuDelegateV2());
    // }

    // Use Metal Delegate
    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }
    // Load model from assets
    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    // Get tensor input shape [1, 224, 224, 3]
    inputTensor = interpreter.getInputTensors().first;
    // Get tensor output shape [1, 1001]
    outputTensor = interpreter.getOutputTensors().first;
  }

  // Load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<void> initHelper() async {
    _loadLabels();
    _loadModel();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  Future<Map<String, double>> _inference(InferenceModel inferenceModel) async {
    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort.send(
      inferenceModel..responsePort = responsePort.sendPort,
    );
    // get inference result.
    var results = await responsePort.first;
    return results;
  }

  // inference camera frame
  // Future<Map<String, double>> inferenceCameraFrame(
  //     CameraImage cameraImage) async {
  //   var isolateModel = InferenceModel(cameraImage, null, interpreter.address,
  //       labels, inputTensor.shape, outputTensor.shape);
  //   return _inference(isolateModel);
  // }

  // inference still image
  Future<Map<String, double>> inferenceImage(img.Image image) async {
    var isolateModel = InferenceModel(
      image,
      interpreter.address,
      labels,
      inputTensor.shape,
      outputTensor.shape,
    );
    return _inference(isolateModel);
  }

  Future<void> close() async {
    isolateInference.close();
  }

  Future<void> processImage() async {
    isLoading = true;
    notifyListeners();
    if (imagePath != null) {
      // Read image bytes from file
      final imageData = File(imagePath!).readAsBytesSync();
      // Decode image using package:image/image.dart (https://pub.dev/image)
      image = img.decodeImage(imageData);
      breedMap = await inferenceImage(image!);
      setUpBreedList();
      // Persist full classification result to local history using SharedPreferences
      await saveHistory();
      isLoading = false;
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> saveHistory() async {
    // Persist full classification result to local history using SharedPreferences
    try {
      // Create a History model that includes the image path, timestamp, and
      // the full list of breed results (ordered by confidence).
      final entry = History(
        imagePath: imagePath ?? '',
        timestamp: DateTime.now(),
        breeds: breedList,
      );

      // Save as a map (LocalStorage expects a Map which it JSON-encodes)
      await LocalStorage.save(key: 'history', item: entry.toMap());
    } catch (e) {
      // ignore storage errors but keep app flow
      debugPrint('Local storage save error: $e');
    }
  }

  void setUpBreedList() {
    breedList =
        (breedMap!.entries
                .map((e) => EachBreed.fromMap(e))
                .where((b) => b.acc > 0)
                .toList()
              ..sort((a, b) => b.acc.compareTo(a.acc)))
            .toList();
  }

  Future<void> pickImage(ImageSource source) async {
    final result = await imagePicker.pickImage(source: source);
    imagePath = result?.path;
    notifyListeners();
  }

  String formatDate(DateTime date) {
    int hour = date.hour;
    String period = 'AM';

    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return '${date.month}/${date.day}/${date.year} '
        '${twoDigits(hour)}:${twoDigits(date.minute)} $period';
  }
}
