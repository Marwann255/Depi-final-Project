import 'dart:convert';
import 'package:flutter/services.dart';

// import 'package:http/http.dart' as http;

class MonumentInfo {
  final int id;
  final String title;
  final String? category;
  final String? period;
  final String? dateRange;
  final String? findSpot;
  final String? source;
  final String? sourceUrl;
  final String? rightsStatement;
  final List<String> materials;
  final List<String> imageUrls;
  final List inscriptions;
  final List entities;

  MonumentInfo({
    required this.id,
    required this.title,
    this.category,
    this.period,
    this.dateRange,
    this.findSpot,
    this.source,
    this.sourceUrl,
    this.rightsStatement,
    required this.materials,
    required this.imageUrls,
    required this.inscriptions,
    required this.entities,
  });

  String get name => title;
  String get era => period ?? dateRange ?? 'Ancient Egypt';
  String get location => findSpot ?? 'Egypt';
  String get summary {
    final parts = <String>[];
    if (dateRange != null && dateRange!.isNotEmpty) parts.add('Date: $dateRange');
    if (period != null && period!.isNotEmpty) parts.add('Period: $period');
    if (findSpot != null && findSpot!.isNotEmpty) parts.add('Find Spot: $findSpot');
    if (category != null && category!.isNotEmpty) parts.add('Category: $category');
    return parts.isNotEmpty ? parts.join('\n') : 'Ancient Egyptian monument artifact.';
  }
  String get hieroglyphName =>
      inscriptions.isNotEmpty ? inscriptions.first.toString() : (category ?? 'Artifact');
  String get wikipediaUrl => sourceUrl ?? 'https://en.wikipedia.org/wiki/Ancient_Egypt';

  factory MonumentInfo.fromLookup(int id, Map<String, dynamic> data) {
    final startBce = data['start_bce'];
    final endBce = data['end_bce'];
    String? date;
    if (startBce != null && endBce != null) {
      date = '${startBce.abs()} BCE – ${endBce.abs()} BCE';
    }
    return MonumentInfo(
      id: id,
      title: data['title']?.toString() ?? 'Unknown Artifact',
      category: data['category']?.toString(),
      period: data['period']?.toString(),
      dateRange: date,
      findSpot: 'Egypt',
      source: 'The Metropolitan Museum of Art',
      sourceUrl: data['record_url']?.toString() ?? data['met_url']?.toString(),
      materials: const [],
      imageUrls: const [],
      inscriptions: const [],
      entities: const [],
    );
  }

  factory MonumentInfo.fromJson(Map<String, dynamic> json) {
    // Handle nested or flat object payload gracefully
    final data = (json['object'] is Map<String, dynamic>)
        ? json['object'] as Map<String, dynamic>
        : json;

    final rawImages = (data['images'] as List<dynamic>?) ?? [];
    final extractedImages = rawImages
        .map((img) {
          if (img is String) return img;
          if (img is Map<String, dynamic>) {
            return (img['url'] ?? img['image_url'] ?? img['src'])?.toString();
          }
          return null;
        })
        .whereType<String>()
        .toList();

    final rawMaterials = (data['materials'] as List<dynamic>?) ?? [];

    return MonumentInfo(
      id: data['id'] is int ? data['id'] : int.tryParse('${data['id']}') ?? 0,
      title: (data['title'] ?? data['name'] ?? 'Unknown Artifact').toString(),
      category: data['category']?.toString(),
      period: data['period']?.toString(),
      dateRange: (data['date_range'] ?? data['date'])?.toString(),
      findSpot: (data['find_spot'] ?? data['findspot'] ?? data['place'])
          ?.toString(),
      source: data['source']?.toString(),
      sourceUrl: data['source_url']?.toString(),
      rightsStatement: data['rights_statement']?.toString(),
      materials: rawMaterials.map((m) => m.toString()).toList(),
      imageUrls: extractedImages,
      inscriptions: ((data['inscriptions'] as List<dynamic>?) ?? [])
          .whereType()
          .toList(),
      entities: ((data['entities'] as List<dynamic>?) ?? [])
          .whereType()
          .toList(),
    );
  }
}

class MonumentRepository {
  static final Map<String, MonumentInfo> _cache = {};
  static bool _isLoaded = false;

  static Future<void> load() async {
    if (_isLoaded) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/lookup.json');
      final Map<String, dynamic> data = jsonDecode(jsonStr);
      data.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          final id = int.tryParse(key) ?? 0;
          _cache[key] = MonumentInfo.fromLookup(id, value);
        }
      });
      _isLoaded = true;
    } catch (e) {
      // Fallback
    }
  }

  static MonumentInfo? findById(int id) {
    return _cache[id.toString()];
  }

  static MonumentInfo? findByLabel(String label) {
    final clean = label.trim();
    if (_cache.containsKey(clean)) {
      return _cache[clean];
    }
    final lower = clean.toLowerCase();
    for (final m in _cache.values) {
      if (m.title.toLowerCase().contains(lower) ||
          m.era.toLowerCase().contains(lower) ||
          (m.category?.toLowerCase().contains(lower) ?? false)) {
        return m;
      }
    }
    return null;
  }
}

class EgyptianInscriptionsService {
  static const String _baseUrl = 'https://egyptianinscriptions.org/api';
  static final Map<int, MonumentInfo> _cache = {};
}
