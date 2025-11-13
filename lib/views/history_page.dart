import 'package:bio_pet/utils/color_const.dart';
import 'package:flutter/material.dart';

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
  final List<DogClassification> historyItems = [
    DogClassification(
      breedName: 'Golden Retriever',
      breedId: 'GR-001',
      date: '11/7/2025 at 8:44:56 AM',
      confidenceScore: 94,
      imageUrl: 'assets/golden_retriever.jpg', // Placeholder for image path
    ),
    DogClassification(
      breedName: 'German Shepherd',
      breedId: 'GS-002',
      date: '11/6/2025 at 8:44:56 AM',
      confidenceScore: 91,
      imageUrl: 'assets/german_shepherd.jpg', // Placeholder for image path
    ),
    DogClassification(
      breedName: 'Golden Retriever',
      breedId: 'GR-001',
      date: '11/7/2025 at 8:44:56 AM',
      confidenceScore: 94,
      imageUrl: 'assets/golden_retriever.jpg', // Placeholder for image path
    ),
    DogClassification(
      breedName: 'German Shepherd',
      breedId: 'GS-002',
      date: '11/6/2025 at 8:44:56 AM',
      confidenceScore: 91,
      imageUrl: 'assets/german_shepherd.jpg', // Placeholder for image path
    ),
    // Add more items here if needed...
  ];

  HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: lightTextColor),
          onPressed: () {
            // Handle back navigation
            Navigator.pop(context);
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
                  'View all your classified dog breeds with unique IDs',
                  style: TextStyle(color: faintTextColor, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: historyItems.length,
        itemBuilder: (context, index) {
          return DogHistoryCard(item: historyItems[index]);
        },
      ),
    );
  }
}

// --- Reusable Card Widget ---

class DogHistoryCard extends StatelessWidget {
  final DogClassification item;

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
                child: Image.asset(
                  item.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Fallback for placeholder images. In a real app, use NetworkImage or proper assets.
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 180,
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
                child: Icon(Icons.delete, color: deleteIconColor, size: 24),
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
                        item.breedName,
                        style: const TextStyle(
                          color: lightTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Breed ID: ',
                            style: TextStyle(
                              color: faintTextColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            item.breedId,
                            style: const TextStyle(
                              color: lightTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.date,
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
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${item.confidenceScore}%',
                    style: const TextStyle(
                      color: lightTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
                onPressed: () {
                  // Handle search details action
                },
                icon: const Icon(Icons.search, size: 18),
                label: const Text('Search More Details'),
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
