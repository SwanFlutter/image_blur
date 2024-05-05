// ignore_for_file: unused_local_variable, unused_element

import 'dart:async';
import 'dart:isolate';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imgs;
import 'package:palette_generator/palette_generator.dart';

class GetImage {
  static Future<String?> getImageHash(String imagePath) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_getImageHashIsolate, receivePort.sendPort);

    final sendPort = await receivePort.first;
    final result = ReceivePort();

    sendPort.send([imagePath, result.sendPort]);
    return await result.first;
  }

  static void _getImageHashIsolate(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      final imagePath = message[0] as String;
      final responseSendPort = message[1] as SendPort;

      String? blurHash;
      try {
        // Fetch the image
        final response = await http.get(Uri.parse(imagePath));
        final rawImage = response.bodyBytes;
        final image = imgs.decodeImage(rawImage);

        if (image != null) {
          // Generate the BlurHash
          blurHash = BlurHash.encode(image, numCompX: 4, numCompY: 3).hash;
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error fetching or encoding image: $e");
        } // Handle potential errors
      }

      responseSendPort.send(blurHash);
    }
  }

  /// Fetches the image and generates the palette

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
