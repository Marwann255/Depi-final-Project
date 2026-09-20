import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScannerScreen extends StatefulWidget {
  final CameraDescription camera;
  const ScannerScreen({super.key, required this.camera});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late final CameraController _controller;
  late final Future<void> _init;
  bool _busy = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _init = _controller.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller.dispose();
  }

  Future<void> _scan() async {
    if (_busy) return;
    setState(() {
      _busy = true;
    });
    try {
      final file = await _controller.takePicture();
      if (!mounted) return;
      Navigator.pop(context, file.path);
    } on CameraException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Capture Failed: ${e.toString()}",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          width: 300,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: const CircularProgressIndicator());
          }
          final size = _controller.value.previewSize!;
          return Stack(
            fit: StackFit.expand,
            children: [
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: size.height,
                  height: size.width,
                  child: CameraPreview(_controller),
                ),
              ),
              // const ScanOverlay();
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _scan,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _busy ? Colors.grey : Colors.white,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
