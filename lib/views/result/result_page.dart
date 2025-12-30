import 'dart:io';

import 'package:bio_pet/models/breed.dart';
import 'package:bio_pet/providers/classification_provider.dart';
import 'package:bio_pet/providers/history_provider.dart';
import 'package:bio_pet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClassificationProvider>();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.lightTextColor),
          onPressed: () async {
            await context.read<HistoryProvider>().loadHistory();
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Back to Classifier',
          style: TextStyle(color: AppColors.lightTextColor, fontSize: 16),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            alignment: Alignment.centerLeft,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Classification Complete',
                  style: TextStyle(
                    color: AppColors.lightTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'AI analysis results',
                  style: TextStyle(
                    color: AppColors.faintTextColor,
                    fontSize: 14,
                  ),
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
            _buildImageSection(provider.imagePath!),
            const SizedBox(height: 20),
            _buildBreedCardList(context, provider.breedList),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        style: TextStyle(color: AppColors.lightTextColor),
                      ),
                    ),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: AppColors.primaryBlue),
                    SizedBox(width: 8),
                    Text(
                      'Classified',
                      style: TextStyle(
                        color: AppColors.lightTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatDate(DateTime.now()),
                  style: const TextStyle(
                    color: AppColors.faintTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Widget _buildBreedCardList(BuildContext context, List<EachBreed> breedList) {
    final List<EachBreed> displayList = List.from(breedList);
    int other = 100 - displayList.fold(0, (sum, item) => sum + item.acc);

    if (other > 0) {
      displayList.add(EachBreed(name: "Other Breeds", acc: other));
    }

    return ListView.separated(
      itemCount: displayList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _buildBreedCard(context, i, displayList),
    );
  }

  Widget _buildBreedCard(
    BuildContext context,
    int index,
    List<EachBreed> breedList,
  ) {
    final bool isMostMatched = index == 0;
    final String breedName = breedList[index].name;
    final int confidence = breedList[index].acc;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: isMostMatched ? 50 : 30,
                      margin: const EdgeInsets.only(right: 10),
                      color: AppColors.primaryBlue,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            breedName.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: AppColors.lightTextColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isMostMatched)
                            const Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
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
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              if (breedName != "Other Breeds")
                InkWell(
                  onTap:
                      () => context.read<HistoryProvider>().openWikipedia(
                        breedName,
                      ),
                  child: const Row(
                    children: [
                      Text(
                        'Read Details ',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          decorationThickness: 2,
                        ),
                      ),
                      Icon(Icons.open_in_new, size: 18, color: Colors.blue),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Accuracy Level',
                style: TextStyle(color: AppColors.lightTextColor, fontSize: 13),
              ),
              Text(
                '$confidence%',
                style: const TextStyle(
                  color: AppColors.lightTextColor,
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
              value: confidence / 100,
              minHeight: 10,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
