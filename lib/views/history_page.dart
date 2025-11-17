import 'dart:io';

import 'package:bio_pet/models/history.dart';
import 'package:bio_pet/providers/classify_provider.dart';
import 'package:bio_pet/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DogClassification {
  final String breedName;
  final String breedId;
  final String date;
  final int confidenceScore;
  final String imageUrl;

  DogClassification({
    required this.breedName,
    required this.breedId,
    required this.date,
    required this.confidenceScore,
    required this.imageUrl,
  });
}

// --- Main History Screen Widget ---

class HistoryPage extends StatelessWidget {
  // Sample data to populate the list

  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: lightTextColor),
          onPressed: () async {
            await context.read<ClassifyProvider>().getHistoryList();
            // print("pressed back");
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Back to Classifier',
          style: TextStyle(color: lightTextColor, fontSize: 16),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Classification History',
                  style: TextStyle(
                    color: lightTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'View all your classified dog breeds',
                  style: TextStyle(color: faintTextColor, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
      body:
          context.watch<ClassifyProvider>().historyList.isEmpty
              ? Center(
                child: Container(
                  // Mimic the border and background of the central widget
                  decoration: BoxDecoration(
                    color: Color(0xFF0D1117),
                    // A subtle, soft border might be around the container
                    border: Border.all(
                      color: const Color(0xFF1E2A36),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    // The shadow is very subtle in the image, often achieved
                    // by the background color difference.
                  ),
                  // Give the container a fixed size, you can adjust this
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    minHeight: 250,
                  ),
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // --- Magnifying Glass Icon ---
                      const Icon(
                        Icons.search,
                        size: 80.0,
                        color: Color(0xFFD4E1F4),
                      ),

                      const SizedBox(height: 20.0),

                      // --- "No Classifications Yet" Text ---
                      const Text(
                        'No Classifications Yet',
                        style: TextStyle(
                          color: Color(0xFFD4E1F4),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10.0),

                      // --- Call-to-Action Link Text ---
                      const Text(
                        'Start classifying dogs to see them appear here',
                        style: TextStyle(
                          color: Color(0xFF58A6FF),
                          fontSize: 14.0,
                          decorationColor: Color(0xFF58A6FF),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: context.watch<ClassifyProvider>().historyList.length,
                itemBuilder: (context, index) {
                  return DogHistoryCard(
                    item: context.watch<ClassifyProvider>().historyList[index],
                  );
                },
              ),
    );
  }
}

// --- Reusable Card Widget ---

class DogHistoryCard extends StatelessWidget {
  final EachClassifying item;

  const DogHistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.file(
                  File(item.imagePath),
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Fallback for placeholder images. In a real app, use NetworkImage or proper assets.
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 400,
                        color: Colors.grey.shade700,
                        child: const Center(
                          child: Text(
                            'Image Unavailable',
                            style: TextStyle(color: lightTextColor),
                          ),
                        ),
                      ),
                ),
              ),
              // Delete Icon
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Handle delete action
                    context.read<ClassifyProvider>().removeFromHistory(item);
                  },
                ),
              ),
            ],
          ),

          // Details Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.breeds[0].name,
                        style: const TextStyle(
                          color: lightTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Row(
                      //   children: [
                      //     const Text(
                      //       'Breed ID: ',
                      //       style: TextStyle(
                      //         color: faintTextColor,
                      //         fontSize: 14,
                      //       ),
                      //     ),
                      //     Text(
                      //       item.breedId,
                      //       style: const TextStyle(
                      //         color: lightTextColor,
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 4),
                      Text(
                        context.read<ClassifyProvider>().formatDate(
                          item.timestamp,
                        ),
                        style: const TextStyle(
                          color: faintTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Confidence Score Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.bar_chart, color: lightTextColor, size: 14),
                      SizedBox(width: 5),
                      Text(
                        '${item.breeds[0].acc}%',
                        style: const TextStyle(
                          color: lightTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Button Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await context.read<ClassifyProvider>().openWikipedia(
                    item.breeds[0].name,
                  );
                  // Handle search details action
                },
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text(
                  'Read More Details',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: lightTextColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: lightTextColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
