import 'dart:io';

import 'package:flutter/material.dart';

class PhotoBox extends StatelessWidget {
  final File? photo;
  const PhotoBox({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 260,
        color: Color(0xff282420),
        child: photo == null
            ? const Center(
                child: Text(
                  'Take a photo of an object to identify it',
                  style: TextStyle(color: Colors.white70),
                ),
              )
            : Image.file(photo!, fit: BoxFit.cover, width: double.infinity),
      ),
    );
  }
}
