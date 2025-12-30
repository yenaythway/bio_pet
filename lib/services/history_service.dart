import 'dart:convert';

import 'package:bio_pet/models/breed.dart';
import 'package:bio_pet/models/history.dart';
import 'package:bio_pet/utils/local_storage.dart';
import 'package:flutter/foundation.dart';

/// Service responsible for managing classification history
class HistoryService {
  static const String _historyKey = 'history';

  /// Save a new classification to history
  Future<void> saveClassification({
    required String imagePath,
    required List<EachBreed> breeds,
  }) async {
    try {
      // Get existing history
      final historyList = await getHistory();

      // Create new entry
      final entry = EachClassifying(
        imagePath: imagePath,
        timestamp: DateTime.now(),
        breeds: breeds,
      );

      // Insert at beginning (newest first)
      historyList.insert(0, entry);

      // Save updated list
      final jsonHistoryList =
          historyList.map((e) => jsonEncode(e.toMap())).toList();
      await LocalStorage.save(key: _historyKey, list: jsonHistoryList);
    } catch (e) {
      debugPrint('Error saving classification to history: $e');
      rethrow;
    }
  }

  /// Get all classification history
  Future<List<EachClassifying>> getHistory() async {
    try {
      final storedItems = await LocalStorage.read(key: _historyKey);
      return storedItems.map((item) => EachClassifying.fromMap(item)).toList();
    } catch (e) {
      debugPrint('Error reading history: $e');
      return [];
    }
  }

  /// Remove a specific entry from history
  Future<void> removeEntry(EachClassifying entry) async {
    try {
      final historyList = await getHistory();
      historyList.removeWhere(
        (item) =>
            item.imagePath == entry.imagePath &&
            item.timestamp == entry.timestamp,
      );

      final jsonHistoryList =
          historyList.map((e) => jsonEncode(e.toMap())).toList();
      await LocalStorage.save(key: _historyKey, list: jsonHistoryList);
    } catch (e) {
      debugPrint('Error removing history entry: $e');
      rethrow;
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    try {
      await LocalStorage.clearHistory(key: _historyKey);
    } catch (e) {
      debugPrint('Error clearing history: $e');
      rethrow;
    }
  }

  /// Get history count
  Future<int> getHistoryCount() async {
    final history = await getHistory();
    return history.length;
  }
}
