import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class RecMatch {
  final int id;
  final double score;
  RecMatch(this.id, this.score);
}

Uint8List _preprocess(String path) {
  const s = Recognizer.size;
  var im = img.decodeImage(File(path).readAsBytesSync())!;
  im = img.bakeOrientation(im);
  im = img.copyResize(
    im,
    width: s,
    height: s,
    interpolation: img.Interpolation.cubic,
  );
  final out = Uint8List(s * s * 3);
  var i = 0;
  for (var y = 0; y < s; y++) {
    for (var x = 0; x < s; x++) {
      final p = im.getPixel(x, y);
      out[i++] = p.r.toInt();
      out[i++] = p.g.toInt();
      out[i++] = p.b.toInt();
    }
  }
  return out;
}

class FrameData {
  final Uint8List bytes;
  final int width,
      height,
      bytesPerRow,
      rotation; // rotation: degrees clockwise to make it upright
  final bool bgra; // false = NV21 (Android)
  FrameData(
    this.bytes,
    this.width,
    this.height,
    this.bytesPerRow,
    this.rotation,
    this.bgra,
  );
}

Uint8List _preprocessFrame(FrameData f) {
  const s = Recognizer.size;
  final w = f.width, h = f.height, r = f.rotation % 360;
  final uw = (r == 90 || r == 270) ? h : w; // upright dimensions
  final uh = (r == 90 || r == 270) ? w : h;
  final side = uw < uh ? uw : uh;
  final ox = (uw - side) ~/ 2, oy = (uh - side) ~/ 2;
  final out = Uint8List(s * s * 3);
  var o = 0;
  for (var j = 0; j < s; j++) {
    for (var i = 0; i < s; i++) {
      final u = ox + ((i + 0.5) * side / s).floor();
      final v = oy + ((j + 0.5) * side / s).floor();
      int sx, sy;
      switch (r) {
        case 90:
          sx = v;
          sy = h - 1 - u;
          break;
        case 180:
          sx = w - 1 - u;
          sy = h - 1 - v;
          break;
        case 270:
          sx = w - 1 - v;
          sy = u;
          break;
        default:
          sx = u;
          sy = v;
      }
      int R, G, B;
      if (f.bgra) {
        final p = sy * f.bytesPerRow + sx * 4;
        B = f.bytes[p];
        G = f.bytes[p + 1];
        R = f.bytes[p + 2];
      } else {
        final y = f.bytes[sy * w + sx];
        final vu = w * h + (sy >> 1) * w + (sx & ~1);
        final vv = f.bytes[vu] - 128, uu = f.bytes[vu + 1] - 128;
        R = (y + 1.402 * vv).round().clamp(0, 255);
        G = (y - 0.344136 * uu - 0.714136 * vv).round().clamp(0, 255);
        B = (y + 1.772 * uu).round().clamp(0, 255);
      }
      out[o++] = R;
      out[o++] = G;
      out[o++] = B;
    }
  }
  return out;
}

class Recognizer {
  static const int size = 224;
  static const int dim = 1280; // matches gallery shape (89, 1280)
  late final Interpreter _interp;
  late final Float32List _gallery;
  late final List<int> _ids;

  Future<List<double>> embed(File file) async =>
      _infer(await compute(_preprocess, file.path));

  Future<List<double>> embedFrame(FrameData f) async =>
      _infer(await compute(_preprocessFrame, f));

  List<double> _infer(Uint8List b) {
    final input = [
      List.generate(
        size,
        (y) => List.generate(size, (x) {
          final o = (y * size + x) * 3;
          return [b[o].toDouble(), b[o + 1].toDouble(), b[o + 2].toDouble()];
        }),
      ),
    ];
    final output = [List<double>.filled(dim, 0)];
    _interp.run(input, output);
    return output[0];
  }

  Future<void> load() async {
    _interp = await Interpreter.fromAsset('assets/model/embedder.tflite');
    final bin = await rootBundle.load('assets/model/embeddings.bin');
    _gallery = bin.buffer.asFloat32List(
      bin.offsetInBytes,
      bin.lengthInBytes ~/ 4,
    );
    _ids = (jsonDecode(
      await rootBundle.loadString('assets/model/gallery_ids.json'),
    ) as List).cast<int>();
    assert(_gallery.length == _ids.length * dim);
  }

  List<RecMatch> match(List<double> q, {int k = 3}) {
    final best = <int, double>{};
    for (var i = 0; i < _ids.length; i++) {
      var dot = 0.0;
      final base = i * dim;
      for (var d = 0; d < dim; d++) {
        dot += _gallery[base + d] * q[d];
      }
      if (dot > (best[_ids[i]] ?? -2)) best[_ids[i]] = dot;
    }
    final list = best.entries.map((e) => RecMatch(e.key, e.value)).toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    return list.take(k).toList();
  }

  void dispose() => _interp.close();
}
