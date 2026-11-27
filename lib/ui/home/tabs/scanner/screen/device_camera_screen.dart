import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharoh_lense/core/service/artifact_repository.dart';
import 'package:pharoh_lense/core/service/recognizer.dart';
import 'package:pharoh_lense/ui/home/tabs/scanner/widgets/photo_box.dart';
import 'package:pharoh_lense/ui/home/tabs/scanner/widgets/result_view.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});
  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  static const _bg = Color(0xff1E1B18);
  // static const _panel = Color(0xff282420);
  static const _gold = Color(0xffd4af37);

  final _rec = Recognizer();
  final _picker = ImagePicker();

  bool _loading = true;
  bool _recReady = false;
  bool _busy = false;
  String? _error;
  File? _photo;
  List<RecMatch> _results = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await ArtifactRepository.load();
      await _rec.load();
      _recReady = true;
    } catch (e) {
      _error = 'Could not load the recognizer: $e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _openCamera() async {
    if (_busy || !_recReady) return;
    setState(() => _busy = true);
    try {
      final x = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );
      if (x == null) return; // user cancelled
      final file = File(x.path);
      final results = _rec.match(await _rec.embed(file));
      for (final r in results) {
        debugPrint('MATCH id=${r.id} score=${r.score.toStringAsFixed(3)}');
      }
      if (!mounted) return;
      setState(() {
        _photo = file;
        _results = results;
      });
    } catch (e) {
      debugPrint('Device camera error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not read that photo. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    if (_recReady) _rec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: _gold,
        title: const Text('Scan with camera'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _gold))
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PhotoBox(photo: _photo == null ? null : _photo),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _busy ? null : _openCamera,
                  icon: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.photo_camera, size: 24),
                  label: Text(
                    _busy
                        ? 'Working...'
                        : (_photo == null ? 'Open camera' : 'Scan again'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                ResultView(results: _results),
              ],
            ),
    );
  }
}
