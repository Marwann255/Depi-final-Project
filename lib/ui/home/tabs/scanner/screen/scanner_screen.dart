import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharoh_lense/core/utils/app_assets.dart';
import 'package:pharoh_lense/ui/home/tabs/scanner/widgets/scan_overlay_widget.dart';

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
      // Navigator.pop(context, file.path);
      print('pressed');
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xff1E1B18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text('Title', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 12),
                Text(
                  'Horus (/hɔːrəs/),[c] also known as Heru, Har, Her, or Hor (/hɔːr/)[d][6] in Ancient Egyptian, is one of the most significant ancient Egyptian deities who served many functions, most notably as the god of kingship, healing, protection, the sun, and the sky. He was worshipped from at least the late prehistoric Egypt until the Ptolemaic Kingdom and Roman Egypt. Different forms of Horus are recorded in history, and these are treated as distinct gods by Egyptologists',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(16),
                        // side: BorderSide(color: Color(0xff)),
                      ),
                      color: Color(0xff282420),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Born In',
                              style: TextStyle(color: Color(0xffd4af37)),
                            ),
                            const SizedBox(height: 12),
                            Text('1000', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(16),
                        // side: BorderSide(color: Color(0xff)),
                      ),
                      color: Color(0xff282420),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Location',
                              style: TextStyle(color: Color(0xffd4af37)),
                            ),
                            const SizedBox(height: 12),
                            Text('Giza', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(16),
                        // side: BorderSide(color: Color(0xff)),
                      ),
                      color: Color(0xff282420),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Name in Heroglafy',
                              style: TextStyle(color: Color(0xffd4af37)),
                            ),
                            const SizedBox(height: 12),
                            Text('1000', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  // alignment: Alignment.center,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffd4af37), Color(0xff6e5b1d)],
                      begin: AlignmentGeometry.topRight,
                      end: AlignmentGeometry.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.wikipediaIcon),
                      const SizedBox(width: 8),
                      Text('View on Wikipedia'),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  // alignment: Alignment.center,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffd9d9d9), Color(0xff737373)],
                      begin: AlignmentGeometry.topRight,
                      end: AlignmentGeometry.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.chatbotIcon),
                      const SizedBox(width: 8),
                      Text('Ask your Tour Guide'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
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
              const ScanOverlayWidget(),
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
                        color: _busy ? Colors.grey : Color(0xffD4AF37),
                        border: Border.all(color: Colors.white, width: 4),
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/icons/icons8-camera-50.png",
                          ),
                        ),
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
