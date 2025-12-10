import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imgs;
import 'package:palette_generator_master/palette_generator_master.dart';

/// Utility class for fetching images and generating color palettes.
class GetImage {
  /// Cache for storing generated palettes.
  static final Map<String, PaletteGeneratorMaster> _paletteCache = {};

  /// Maximum cache size for palettes.
  static int _maxCacheSize = 50;

  /// Sets the maximum cache size for palettes.
  static void setMaxCacheSize(int size) {
    _maxCacheSize = size;
    _cleanupCache();
  }

  /// Clears all cached palettes.
  static void clearCache() {
    _paletteCache.clear();
  }

  /// Fetches an image from URL and generates its color palette.
  ///
  /// [imageUrl] The URL of the image to fetch.
  /// [forceRefresh] If true, bypasses cache and generates new palette.
  ///
  /// Returns a [PaletteGeneratorMaster] containing the dominant colors,
  /// or null if the operation fails.
  static Future<PaletteGeneratorMaster?> fetchImageAndGeneratePalette(
    String imageUrl, {
    bool forceRefresh = false,
  }) async {
    // Check cache first
    if (!forceRefresh && _paletteCache.containsKey(imageUrl)) {
      return _paletteCache[imageUrl];
    }

    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final imageData = response.bodyBytes;
        final image = imgs.decodeImage(imageData);
        if (image != null) {
          final paletteGenerator =
              await PaletteGeneratorMaster.fromImageProvider(
                MemoryImage(imageData),
              );

          // Cache the result
          _paletteCache[imageUrl] = paletteGenerator;
          _cleanupCache();

          return paletteGenerator;
        } else {
          if (kDebugMode) {
            debugPrint('GetImage: Failed to decode image from $imageUrl');
          }
        }
      } else {
        if (kDebugMode) {
          debugPrint(
            'GetImage: Failed to load image from $imageUrl (Status: ${response.statusCode})',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('GetImage: Error fetching image - $e');
      }
    }
    return null;
  }

  /// Cleanup cache if it exceeds max size.
  static void _cleanupCache() {
    if (_paletteCache.length > _maxCacheSize) {
      final keysToRemove = _paletteCache.keys
          .take(_paletteCache.length - _maxCacheSize)
          .toList();
      for (final key in keysToRemove) {
        _paletteCache.remove(key);
      }
    }
  }
}
