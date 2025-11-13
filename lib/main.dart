import 'package:bio_pet/providers/classify_provider.dart';
import 'package:bio_pet/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ClassifyProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

// Helper Widget for the breed entry
class BreedMatchTile extends StatelessWidget {
  final String breedName;
  final double confidence;
  final bool isHighestMatch;

  const BreedMatchTile({
    super.key,
    required this.breedName,
    required this.confidence,
    this.isHighestMatch = false,
  });

  @override
  Widget build(BuildContext context) {
    // Convert confidence from 0.0-1.0 to 0-100%
    final int confidencePercent = (confidence * 100).round();
    final Color barColor = isHighestMatch ? Colors.blue : Colors.blue.shade200;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    breedName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isHighestMatch)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Highest Match',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                '$confidencePercent%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: confidence,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          // Search more details button (simplified as a text row)
          Row(
            children: [
              const Icon(Icons.search, size: 16, color: Colors.blue),
              const SizedBox(width: 4),
              const Text(
                'Search more details',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.open_in_new, size: 14, color: Colors.blue),
            ],
          ),
        ],
      ),
    );
  }
}

class ClassificationResultScreen extends StatelessWidget {
  const ClassificationResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The main color palette is dark blue and white/light grey
    const Color primaryBlue = Color(0xFF0056D2); // A dark/vibrant blue

    return Scaffold(
      // Top section with status bar and back button
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hide default back button
        backgroundColor: Colors.transparent, // Transparent for the custom look
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                // Handle back action
              },
            ),
            const SizedBox(width: 10),
            const Icon(Icons.psychology_alt, color: primaryBlue),
            const SizedBox(width: 8),
            const Text(
              'Classification Complete',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Detection Summary
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                'AI detected 2 possible breeds',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
            ),

            // --- Bio Pet Header Section ---
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Image/Logo Section
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Dog and Cat outline image placeholder
                        const Icon(
                          Icons.pets, // Using a generic pet icon for simplicity
                          size: 100,
                          color: primaryBlue,
                        ),
                        // The "Bio Pet" text
                        Text(
                          'Bio Pet',
                          style: TextStyle(
                            fontFamily:
                                'CustomFont', // Replace with a custom font that looks like the image
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: primaryBlue,
                            shadows: [
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.blue.shade100,
                                offset: const Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Classification Status Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.fiber_manual_record,
                              color: primaryBlue,
                              size: 10,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Classified',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '11/10/2025 21:08',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Detected Breeds Section ---
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Text(
                'Detected Breeds',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Breed Match Cards Container
            Container(
              margin: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 20.0,
              ),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  // Golden Retriever
                  BreedMatchTile(
                    breedName: 'Golden Retriever',
                    confidence: 0.53,
                    isHighestMatch: true,
                  ),
                  Divider(height: 0),
                  // Poodle
                  BreedMatchTile(
                    breedName: 'Poodle',
                    confidence: 0.47,
                    isHighestMatch: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
