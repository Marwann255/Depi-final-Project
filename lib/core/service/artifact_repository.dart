import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pharoh_lense/core/models/monument_info.dart';

class ArtifactRepository {
  static Map<String, dynamic> _data = {};
  static Future<void> load() async =>
      _data = jsonDecode(await rootBundle.loadString('assets/lookup.json'));
  static Map<String, dynamic>? byId(int id) =>
      _data['$id'] as Map<String, dynamic>?;
}

class SheetData {
  final String title, summary, linkLabel, badge;
  final Map<String, String> cards; // label -> value, shown in order
  final String? url;
  SheetData({
    required this.title,
    required this.summary,
    required this.cards,
    required this.linkLabel,
    required this.badge,
    this.url,
  });

  factory SheetData.fromMonument(MonumentInfo m, double confidence) =>
      SheetData(
        title: m.name,
        summary: m.summary,
        cards: {
          'Era / Built': m.era,
          'Location': m.location,
          'Hieroglyph': m.hieroglyphName,
        },
        url: m.wikipediaUrl,
        linkLabel: 'View on Wikipedia',
        badge: '${(confidence * 100).toStringAsFixed(0)}%',
      );

  factory SheetData.fromArtifact(Map<String, dynamic> a, double similarity) {
    final startNum = a['start_bce'] as num?;
    final endNum = a['end_bce'] as num?;
    final datesStr = (startNum != null && endNum != null)
        ? '${startNum.abs().toInt()}-${endNum.abs().toInt()} BCE'
        : (a['period']?.toString() ?? '-');

    return SheetData(
      title: a['title'] as String? ?? 'Ancient Artifact',
      summary: 'From the Metropolitan Museum of Art collection.',
      cards: {
        'Category': '${a['category'] ?? '-'}',
        'Period': '${a['period'] ?? '-'}',
        'Dates': datesStr,
      },
      url: (a['met_url'] ?? a['record_url']) as String?,
      linkLabel: 'View on the Met',
      badge: 'sim ${similarity.toStringAsFixed(2)}', // dev only, remove before release
    );
  }
}
