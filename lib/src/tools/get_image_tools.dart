// ignore_for_file: unused_local_variable, unused_element

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imgs;
import 'package:palette_generator/palette_generator.dart';

class GetImage {
  static Future<PaletteGenerator?> fetchImageAndGeneratePalette(
      String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final imageData = response.bodyBytes;
        final image = imgs.decodeImage(imageData);
        if (image != null) {
          final paletteGenerator = await PaletteGenerator.fromImageProvider(
            MemoryImage(imageData),
          );
          return paletteGenerator;
        } else {
          debugPrint('Error: Failed to decode image');
        }
      } else {
        throw Exception(
            "Failed to load image (Status code: ${response.statusCode})");
      }
    } on Exception catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }
}
