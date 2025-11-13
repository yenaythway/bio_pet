import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Simple local storage helper using SharedPreferences to store
/// classification history as a list of JSON-encoded strings.
class LocalStorage {
  // static const String _kHistoryKey = 'classification_history';

  /// Save a classification item (Map) by appending to the history list.
  /// The item will be encoded as JSON.
  static Future<void> save({
    required String key,
    required Map<String, dynamic> item,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(key) ?? [];
    // Prepend newest item so history shows recent first
    list.insert(0, jsonEncode(item));
    await prefs.setStringList(key, list);
  }

  /// Read all history items and decode them into maps.
  static Future<List<Map<String, dynamic>>> readHistory({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(key) ?? [];
    final decoded = <Map<String, dynamic>>[];
    for (final s in list) {
      try {
        final m = jsonDecode(s) as Map<String, dynamic>;
        decoded.add(m);
      } catch (_) {
        // ignore individual decode errors
      }
    }
    return decoded;
  }

  /// Clear the stored history
  static Future<void> clearHistory({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
