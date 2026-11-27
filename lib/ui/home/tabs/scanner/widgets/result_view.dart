import 'package:flutter/material.dart';
import 'package:pharoh_lense/core/router/route_name.dart';
import 'package:pharoh_lense/core/service/artifact_repository.dart';
import 'package:pharoh_lense/core/service/recognizer.dart';

class ResultView extends StatelessWidget {
  final List<RecMatch> results;
  const ResultView({super.key, required this.results});

  static const double kHigh = 0.80; // placeholder, calibrate
  static const double kLow = 0.55; // placeholder, calibrate
  static const double kMargin = 0.05; // placeholder, calibrate

  String get _confidenceLabel {
    final top = results.first;
    final gap = results.length > 1 ? top.score - results[1].score : 1.0;
    if (top.score >= kHigh && gap >= kMargin) return 'Confident match';
    if (top.score >= kLow) return 'Probable match';
    return 'Weak match - this may not be in the collection';
  }

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) return const SizedBox.shrink();
    final top = results.first;
    final a = ArtifactRepository.byId(top.id);
    if (a == null) return const SizedBox.shrink();
    final d = SheetData.fromArtifact(a, top.score);
    final weak = _confidenceLabel.startsWith('Weak');

    return Card(
      color: Color(0xff282420),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              d.title,
              style: const TextStyle(
                color: Color(0xffd4af37),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _confidenceLabel,
              style: TextStyle(
                color: weak ? Colors.orangeAccent : Colors.white70,
                fontSize: 13,
              ),
            ),
            for (final e in d.cards.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(
                        e.key,
                        style: const TextStyle(
                          color: Color(0xffd4af37),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        e.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // SizedBox(height: 8, width: 8, child: Placeholder()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, RouteName.chatbot),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffd4af37),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/Botx3.png',
                    width: 24,
                    height: 24,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Text('Ask Your AI Agent'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
