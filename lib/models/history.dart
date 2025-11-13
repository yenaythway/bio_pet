import 'dart:convert';

import 'package:bio_pet/models/breed.dart';

/// History model for a classification attempt.
///
/// This was previously named `HistoryEntry`. A small `HistoryEntry` subclass
/// is provided at the end of the file for backward compatibility.
class History {
  /// Local file path of the image used for classification (can be empty/null if not stored).
  final String imagePath;

  /// Timestamp of when the classification occurred.
  final DateTime timestamp;

  /// Top breed results returned by the classifier (ordered by confidence desc).
  final List<EachBreed> breeds;

  History({
    required this.imagePath,
    required this.timestamp,
    required this.breeds,
  });

  factory History.fromMap(Map<String, dynamic> map) {
    final breedList = <EachBreed>[];
    if (map['breeds'] is List) {
      for (final item in (map['breeds'] as List)) {
        if (item is MapEntry) {
          // EachBreed factory expects MapEntry<String,double>
          try {
            final entry = item as MapEntry<String, double>;
            breedList.add(EachBreed.fromMap(entry));
            continue;
          } catch (_) {}
        }

        if (item is Map) {
          // stored as {'name':.., 'acc': ..}
          final name = item['name']?.toString() ?? '';
          final acc =
              (item['acc'] is int)
                  ? item['acc'] as int
                  : (int.tryParse(item['acc']?.toString() ?? '') ?? 0);
          breedList.add(EachBreed(name: name, acc: acc));
        } else if (item is String) {
          // if stored as json string
          try {
            final m = json.decode(item) as Map<String, dynamic>;
            final name = m['name']?.toString() ?? '';
            final acc =
                (m['acc'] is int)
                    ? m['acc'] as int
                    : (int.tryParse(m['acc']?.toString() ?? '') ?? 0);
            breedList.add(EachBreed(name: name, acc: acc));
          } catch (_) {}
        }
      }
    }

    return History(
      imagePath: map['imagePath'] as String? ?? '',
      timestamp:
          DateTime.tryParse(map['timestamp'] as String? ?? '') ??
          DateTime.now(),
      breeds: breedList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
      'breeds': breeds.map((b) => b.toJson()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory History.fromJson(String source) =>
      History.fromMap(json.decode(source) as Map<String, dynamic>);

  History copyWith({
    String? imagePath,
    DateTime? timestamp,
    List<EachBreed>? breeds,
  }) {
    return History(
      imagePath: imagePath ?? this.imagePath,
      timestamp: timestamp ?? this.timestamp,
      breeds: breeds ?? this.breeds,
    );
  }

  @override
  String toString() =>
      'History(imagePath: $imagePath, timestamp: $timestamp, breeds: $breeds)';
}

/// Backwards-compatible wrapper: keep `HistoryEntry` name working for callers
/// that still reference it.
class HistoryEntry extends History {
  HistoryEntry({
    required String imagePath,
    required DateTime timestamp,
    required List<EachBreed> breeds,
  }) : super(imagePath: imagePath, timestamp: timestamp, breeds: breeds);

  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    final h = History.fromMap(map);
    return HistoryEntry(
      imagePath: h.imagePath,
      timestamp: h.timestamp,
      breeds: h.breeds,
    );
  }

  factory HistoryEntry.fromJson(String source) {
    final h = History.fromJson(source);
    return HistoryEntry(
      imagePath: h.imagePath,
      timestamp: h.timestamp,
      breeds: h.breeds,
    );
  }
}
