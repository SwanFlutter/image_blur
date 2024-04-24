import 'dart:async';
import 'dart:isolate';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imgs;

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
}
