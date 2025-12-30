# Bio Pet - AI Pet Breed Classifier

## Project Overview
Flutter mobile app for **offline AI pet breed classification** using TensorFlow Lite. Identifies dog and cat breeds via camera/gallery with on-device ML inference. Uses MobileNet quantized model for privacy and speed without internet connectivity.

## Architecture (MVP Pattern with Provider)

### Structure
```
lib/
├── models/          # Data models (EachBreed, EachClassifying)
├── services/        # Business logic layer
│   ├── classification_service.dart  # ML inference operations
│   └── history_service.dart         # History persistence
├── providers/       # Presenters (state management)
│   ├── classification_provider.dart # Classification state
│   └── history_provider.dart        # History state
├── views/           # UI screens
│   ├── home/
│   ├── result/
│   └── history/
├── widgets/         # Reusable UI components
├── utils/           # Helpers and constants
└── helper/          # Isolate inference
```

### Core Components

**Services (Business Logic)**
- **ClassificationService** ([lib/services/classification_service.dart](lib/services/classification_service.dart)): ML inference operations
  - Loads TFLite model with platform-specific delegates (XNNPACK/Metal)
  - Manages isolate-based inference to prevent UI blocking
  - Input: 224x224x3 images → Output: Map<String, double> breed probabilities
- **HistoryService** ([lib/services/history_service.dart](lib/services/history_service.dart)): Persistence layer
  - Saves/loads classification history via SharedPreferences
  - Stores JSON-encoded `EachClassifying` objects

**Providers (Presenters)**
- **ClassificationProvider**: Manages classification workflow state
  - Orchestrates: image picking → classification → history saving
  - Exposes: `isLoading`, `imagePath`, `breedList`, `errorMessage`
- **HistoryProvider**: Manages history display and operations
  - Handles: loading history, removing entries, Wikipedia links
  - Exposes: `historyList`, `historyCount`, `formatDate()`

**Views (UI)**
- **HomePage**: Image selection and classification trigger
- **ResultPage**: Display classification results with confidence scores
- **HistoryPage**: List all past classifications

### Data Flow
1. User picks image → `ClassificationProvider.pickImage()`
2. User triggers classification → `ClassificationProvider.classifyImage()`
3. Provider calls `ClassificationService.processImageFile()`
4. Service spawns isolate, resizes image to 224x224, runs TFLite
5. Results sorted by confidence → saved via `HistoryService`
6. UI updates via `notifyListeners()`

## Key Conventions

### Provider Initialization Pattern
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<ClassificationProvider>().initialize();
    context.read<HistoryProvider>().loadHistory();
  });
}
```
**Critical**: Always initialize providers in `addPostFrameCallback` to avoid calling Provider before widget tree builds.

### Service Dependency Injection
```dart
// In main.dart
final classificationService = ClassificationService();
final historyService = HistoryService();

MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => ClassificationProvider(
        classificationService: classificationService,
        historyService: historyService,
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => HistoryProvider(historyService: historyService),
    ),
  ],
  child: const MyApp(),
);
```

### Models & Data Structures
- **EachBreed**: Single classification result with `name` (label) and `acc` (confidence 0-100)
- **EachClassifying**: History entry with `imagePath`, `timestamp`, `List<EachBreed> breeds`
  - Always insert new entries at index 0 (newest first)
  - Stored as JSON string list in SharedPreferences key `'history'`

### UI & Styling
- **Constants**: Use `AppColors` and `AppTextStyles` from [lib/utils/constants.dart](lib/utils/constants.dart)
  - Colors: `darkBlueBackground`, `primaryBlue`, `secondaryBlue`, `cardColor`
  - Styles: `mainTitle`, `heading`, `bodyText`, `smallText`
- **Responsive**: Use `Responsive.wp()` / `Responsive.hp()` for all dimensions

## Development Workflows

### Running the App
```bash
flutter pub get
flutter run

# Generate app icons
flutter pub run flutter_launcher_icons
```

### Adding New ML Models
1. Place `.tflite` model in `assets/models/`
2. Update `labels.txt` (one class per line)
3. Modify `_modelPath` and `_labelsPath` in `ClassificationService`
4. Adjust input shape in `processImageFile()` if model differs from 224x224

### Testing
- Default test: [test/widget_test.dart](test/widget_test.dart) (outdated counter test)
- **To test**: Mock `ClassificationService` and test provider state changes

## Critical Gotchas

1. **Isolate Communication**: Never pass mutable objects to isolates. Current implementation passes `interpreter.address` (int pointer).

2. **Service Initialization**: 
   - `ClassificationService.initialize()` **must** be called before inference
   - Check `isInitialized` property before operations

3. **SharedPreferences**: 
   - `HistoryService.saveClassification()` saves **entire list**, not incremental
   - History list reversed (newest first) - always `insert(0, entry)`

4. **Image Package**: Use `image` package for decoding/manipulation. `image_picker` only retrieves paths.

5. **Provider Context**: Never call `context.read<T>()` in `build()` - use `context.watch<T>()` for reactive updates.

## External Dependencies
- **tflite_flutter**: TensorFlow Lite on-device inference
- **image**: Image decoding/resizing (NOT Flutter's Image widget)
- **image_picker**: Camera/gallery access
- **provider**: State management (MVP presenters)
- **shared_preferences**: Local persistence
- **url_launcher**: Open Wikipedia in browser

