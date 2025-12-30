import 'package:bio_pet/models/history.dart';
import 'package:bio_pet/services/history_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Provider for managing history state and operations
class HistoryProvider extends ChangeNotifier {
  final HistoryService _historyService;

  HistoryProvider({required HistoryService historyService})
    : _historyService = historyService;

  // State
  List<EachClassifying> _historyList = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<EachClassifying> get historyList => _historyList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get historyCount => _historyList.length;
  bool get hasHistory => _historyList.isNotEmpty;

  /// Load history from storage
  Future<void> loadHistory() async {
    try {
      _isLoading = true;
      notifyListeners();

      _historyList = await _historyService.getHistory();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load history: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Remove a specific entry from history
  Future<void> removeEntry(EachClassifying entry) async {
    try {
      await _historyService.removeEntry(entry);
      _historyList.removeWhere(
        (item) =>
            item.imagePath == entry.imagePath &&
            item.timestamp == entry.timestamp,
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to remove entry: $e';
      notifyListeners();
    }
  }

  /// Clear all history
  Future<void> clearAllHistory() async {
    try {
      await _historyService.clearHistory();
      _historyList = [];
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to clear history: $e';
      notifyListeners();
    }
  }

  /// Format timestamp for display
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

  /// Open Wikipedia page for a breed
  Future<void> openWikipedia(String keyword) async {
    final url = Uri.parse("https://en.wikipedia.org/wiki/$keyword");

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _errorMessage = "Could not launch $url";
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Failed to open Wikipedia: $e";
      notifyListeners();
    }
  }
}
