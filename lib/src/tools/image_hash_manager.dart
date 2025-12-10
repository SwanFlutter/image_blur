// Utility class for managing image hash operations with persistent Isolate
import 'dart:async';
import 'dart:isolate';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imgs;

/// A utility class for generating and caching BlurHash values for images.
///
/// Uses a persistent Isolate for fast, non-blocking BlurHash generation.
/// Includes caching to avoid redundant computations.
class ImageHashManager {
  /// In-memory cache for storing computed BlurHash values.
  static final Map<String, String> _cache = {};

  /// Maximum number of cached items before cleanup.
  static int _maxCacheSize = 100;

  /// Pending requests waiting for the same image.
  static final Map<String, Completer<String?>> _pendingRequests = {};

  /// Persistent Isolate components.
  static Isolate? _isolate;
  static SendPort? _sendPort;
  static ReceivePort? _receivePort;
  static final Map<int, Completer<String?>> _requestCompleters = {};
  static int _requestId = 0;

  /// Lock for isolate initialization.
  static Completer<void>? _initializingCompleter;

  /// Sets the maximum cache size. Default is 100.
  static void setMaxCacheSize(int size) {
    _maxCacheSize = size;
    _cleanupCache();
  }

  /// Clears all cached BlurHash values.
  static void clearCache() {
    _cache.clear();
  }

  /// Removes a specific image from cache.
  static void removeFromCache(String imagePath) {
    _cache.remove(imagePath);
  }

  /// Returns the number of cached items.
  static int get cacheSize => _cache.length;

  /// Disposes the persistent Isolate. Call when no longer needed.
  static void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _receivePort?.close();
    _receivePort = null;
    _sendPort = null;
    _initializingCompleter = null;
    _requestCompleters.clear();
    _pendingRequests.clear();
  }

  /// Initializes the persistent Isolate if not already running.
  static Future<void> _ensureIsolateReady() async {
    // Already initialized
    if (_sendPort != null) return;

    // Already initializing - wait for it
    if (_initializingCompleter != null) {
      await _initializingCompleter!.future;
      return;
    }

    // Start initialization
    _initializingCompleter = Completer<void>();

    try {
      _receivePort = ReceivePort();
      _isolate = await Isolate.spawn(_isolateEntry, _receivePort!.sendPort);

      final sendPortCompleter = Completer<SendPort>();

      _receivePort!.listen((message) {
        if (message is SendPort) {
          sendPortCompleter.complete(message);
        } else if (message is _BlurHashResult) {
          final requestCompleter = _requestCompleters.remove(message.requestId);
          requestCompleter?.complete(message.hash);
        }
      });

      _sendPort = await sendPortCompleter.future;
      _initializingCompleter!.complete();
    } catch (e) {
      _initializingCompleter!.completeError(e);
      _initializingCompleter = null;
      rethrow;
    }
  }

  /// Gets the BlurHash for an image, using cache if available.
  ///
  /// [imagePath] The URL or path of the image.
  /// [forceRefresh] If true, bypasses cache and generates new hash.
  /// [numCompX] Number of horizontal components (1-9). Default is 4.
  /// [numCompY] Number of vertical components (1-9). Default is 3.
  static Future<String?> getImageHash(
    String imagePath, {
    bool forceRefresh = false,
    int numCompX = 4,
    int numCompY = 3,
  }) async {
    // Check cache first
    if (!forceRefresh && _cache.containsKey(imagePath)) {
      return _cache[imagePath];
    }

    // Check if there's already a pending request for this image
    if (_pendingRequests.containsKey(imagePath)) {
      return _pendingRequests[imagePath]!.future;
    }

    // Create a pending request
    final pendingCompleter = Completer<String?>();
    _pendingRequests[imagePath] = pendingCompleter;

    try {
      await _ensureIsolateReady();

      final requestId = _requestId++;
      final completer = Completer<String?>();
      _requestCompleters[requestId] = completer;

      _sendPort!.send(
        _BlurHashRequest(
          requestId: requestId,
          imagePath: imagePath,
          numCompX: numCompX,
          numCompY: numCompY,
        ),
      );

      final hash = await completer.future;

      if (hash != null) {
        _cache[imagePath] = hash;
        _cleanupCache();
      }

      pendingCompleter.complete(hash);
      return hash;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error generating BlurHash: $e");
      }
      pendingCompleter.complete(null);
      return null;
    } finally {
      _pendingRequests.remove(imagePath);
    }
  }

  /// Preloads BlurHash for multiple images concurrently.
  static Future<Map<String, String?>> preloadHashes(
    List<String> imagePaths, {
    int numCompX = 4,
    int numCompY = 3,
  }) async {
    final futures = imagePaths.map((path) async {
      final hash = await getImageHash(
        path,
        numCompX: numCompX,
        numCompY: numCompY,
      );
      return MapEntry(path, hash);
    });

    final results = await Future.wait(futures);
    return Map.fromEntries(results);
  }

  /// Cleanup cache if it exceeds max size (removes oldest entries).
  static void _cleanupCache() {
    if (_cache.length > _maxCacheSize) {
      final keysToRemove = _cache.keys
          .take(_cache.length - _maxCacheSize)
          .toList();
      for (final key in keysToRemove) {
        _cache.remove(key);
      }
    }
  }
}

/// Entry point for the persistent Isolate.
void _isolateEntry(SendPort mainSendPort) {
  final receivePort = ReceivePort();
  mainSendPort.send(receivePort.sendPort);

  receivePort.listen((message) async {
    if (message is _BlurHashRequest) {
      final hash = await _generateBlurHash(message);
      mainSendPort.send(
        _BlurHashResult(requestId: message.requestId, hash: hash),
      );
    }
  });
}

/// Generates BlurHash for a single image (runs in Isolate).
Future<String?> _generateBlurHash(_BlurHashRequest request) async {
  try {
    final response = await http.get(Uri.parse(request.imagePath));

    if (response.statusCode != 200) {
      return null;
    }

    final rawImage = response.bodyBytes;
    final image = imgs.decodeImage(rawImage);

    if (image != null) {
      return BlurHash.encode(
        image,
        numCompX: request.numCompX,
        numCompY: request.numCompY,
      ).hash;
    }
  } catch (e) {
    // Error handled by caller
  }
  return null;
}

/// Request message for BlurHash generation.
class _BlurHashRequest {
  final int requestId;
  final String imagePath;
  final int numCompX;
  final int numCompY;

  const _BlurHashRequest({
    required this.requestId,
    required this.imagePath,
    required this.numCompX,
    required this.numCompY,
  });
}

/// Result message from BlurHash generation.
class _BlurHashResult {
  final int requestId;
  final String? hash;

  const _BlurHashResult({required this.requestId, required this.hash});
}
