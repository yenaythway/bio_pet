import 'dart:io';

import 'package:bio_pet/models/breed.dart';
import 'package:bio_pet/providers/classify_provider.dart';
import 'package:bio_pet/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

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
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Classification Complete',
                  style: TextStyle(
                    color: lightTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'AI analysis results',
                  style: TextStyle(color: faintTextColor, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Dog Image Section
            _buildImageSection(context.read<ClassifyProvider>().imagePath!),
            const SizedBox(height: 20),

            // 2. Classification Details Card
            _buildBreedCardList(context.read<ClassifyProvider>().breedList),
          ],
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildImageSection(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Image.file(
              File(imagePath),
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 300,
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

          // Status Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.circle, size: 8, color: primaryBlue),
                    SizedBox(width: 8),
                    Text(
                      'Classified',
                      style: TextStyle(color: lightTextColor, fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  '11/8/2025',
                  style: TextStyle(color: faintTextColor, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreedCardList(List<EachBreed> breedList) {
    int other = 100 - breedList.fold(0, (sum, item) => sum + item.acc);
    if (other > 0) {
      breedList.add(EachBreed(name: "Other Breeds", acc: other));
    }
    return ListView.separated(
      itemCount: breedList.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        return _buildBreedCard(context, i, breedList);
      },
    );
  }

  Widget _buildBreedCard(
    BuildContext context,
    int index,
    List<EachBreed> breedList,
  ) {
    {
      bool isMostMatched = index == 0;
      String breedName = breedList[index].name;
      int confidence = breedList[index].acc;
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breed Name & AI Confidence
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 3,
                        height: isMostMatched ? 50 : 30,
                        margin: const EdgeInsets.only(right: 10),
                        color: primaryBlue,
                      ),

                      // SizedBox(width: 8),

                      // SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              breedName.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: lightTextColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isMostMatched)
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                  Text(
                                    "Most Matched",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
                if (breedName != "Other Breeds")
                  InkWell(
                    onTap: () async {
                      await context.read<ClassifyProvider>().openWikipedia(
                        breedName,
                      );
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Read Details ',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            decorationColor:
                                Colors
                                    .blue, // Optional: customize underline color
                            decorationThickness:
                                2, // Optional: customize underline thickness
                            decorationStyle: TextDecorationStyle.solid,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Icon(Icons.open_in_new, size: 18, color: Colors.blue),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Accuracy Level',
                  style: TextStyle(color: lightTextColor, fontSize: 13),
                ),
                Text(
                  '$confidence%',
                  style: const TextStyle(
                    color: lightTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: LinearProgressIndicator(
                value: confidence / 100, // 0.96 for 96%
                minHeight: 10,
                // backgroundColor: Colors.black.withAlpha(10),
                valueColor: const AlwaysStoppedAnimation<Color>(primaryBlue),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    }
  }
}
