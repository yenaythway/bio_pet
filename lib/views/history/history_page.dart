import 'dart:io';

import 'package:bio_pet/models/history.dart';
import 'package:bio_pet/providers/history_provider.dart';
import 'package:bio_pet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.lightTextColor),
          onPressed: () async {
            await provider.loadHistory();
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
          preferredSize: const Size.fromHeight(40.0),
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            alignment: Alignment.centerLeft,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Classification History',
                  style: TextStyle(
                    color: AppColors.lightTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'View all your classified pet breeds',
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
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : !provider.hasHistory
              ? _buildEmptyState()
              : ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: provider.historyList.length,
                itemBuilder: (context, index) {
                  return HistoryCard(item: provider.historyList[index]);
                },
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          border: Border.all(color: const Color(0xFF1E2A36), width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        constraints: const BoxConstraints(maxWidth: 400, minHeight: 250),
        padding: const EdgeInsets.all(40.0),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80.0, color: Color(0xFFD4E1F4)),
            SizedBox(height: 20.0),
            Text(
              'No Classifications Yet',
              style: TextStyle(
                color: Color(0xFFD4E1F4),
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Start classifying pets to see them appear here',
              style: TextStyle(color: Color(0xFF58A6FF), fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final EachClassifying item;

  const HistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HistoryProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 400,
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
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, provider),
                ),
              ),
            ],
          ),
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
                        item.breeds.isNotEmpty
                            ? item.breeds[0].name
                            : 'Unknown',
                        style: const TextStyle(
                          color: AppColors.lightTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        provider.formatDate(item.timestamp),
                        style: const TextStyle(
                          color: AppColors.faintTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bar_chart,
                        color: AppColors.lightTextColor,
                        size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${item.breeds.isNotEmpty ? item.breeds[0].acc : 0}%',
                        style: const TextStyle(
                          color: AppColors.lightTextColor,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (item.breeds.isNotEmpty) {
                    provider.openWikipedia(item.breeds[0].name);
                  }
                },
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text(
                  'Read More Details',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.lightTextColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.lightTextColor,
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

  Future<void> _confirmDelete(
    BuildContext context,
    HistoryProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color.fromARGB(200, 93, 155, 255),
            content: const Text(
              'Are you sure you want to delete this classification from history?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true && context.mounted) {
      await provider.removeEntry(item);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('History entry deleted')));
      }
    }
  }
}
