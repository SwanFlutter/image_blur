import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:http/http.dart' as http;
import 'package:image_blur/image_blur.dart';

/// A widget that displays an optimized image preview using a BlurHash placeholder.
///
/// This widget first displays a BlurHash preview while the actual image is being
/// loaded. Once the image is loaded, it smoothly transitions to the actual image.
/// This provides a better user experience by avoiding a sudden image pop-in.
class OptimizedImageHashPreview extends StatefulWidget {
  /// The path to the image. Can be a local path or a network URL.
  final String imagePath;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// How to inscribe the image into the space allocated during layout.
  /// The default value is [BoxFit.cover].
  final BoxFit fit;

  /// The color to use as a placeholder before the BlurHash is loaded.
  final Color? placeholderColor;

  /// The border radius of the image.
  final BorderRadiusGeometry borderRadius;

  /// The duration of the fade-in animation when the actual image is loaded.
  final Duration duration;

  /// A callback function that is called when the image is fully loaded.
  final Function()? onLoaded;

  /// A callback function that is called when an error occurs.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Delay before starting to load the actual image after hash is loaded.
  /// Set to Duration.zero to start immediately.
  final Duration hashLoadDelay;

  /// Delay before showing the actual image after it's loaded.
  /// This allows the BlurHash to be visible for a minimum time.
  final Duration imageShowDelay;

  /// The width to decode the BlurHash. Higher values = more detail but slower.
  final int decodingWidth;

  /// The height to decode the BlurHash. Higher values = more detail but slower.
  final int decodingHeight;

  /// The quality of the image filtering.
  final FilterQuality filterQuality;

  /// Creates an [OptimizedImageHashPreview] widget.
  const OptimizedImageHashPreview({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderColor,
    this.borderRadius = BorderRadius.zero,
    this.duration = const Duration(milliseconds: 500),
    this.onLoaded,
    this.errorBuilder,
    this.hashLoadDelay = const Duration(milliseconds: 100),
    this.imageShowDelay = const Duration(milliseconds: 300),
    this.decodingWidth = 32,
    this.decodingHeight = 32,
    this.filterQuality = FilterQuality.high,
  });

  @override
  State<OptimizedImageHashPreview> createState() =>
      _OptimizedImageHashPreviewState();
}

class _OptimizedImageHashPreviewState extends State<OptimizedImageHashPreview>
    with SingleTickerProviderStateMixin {
  late Future<String?> imageHashFuture;
  ui.Image? cachedImage;
  late AnimationController _controller;
  bool _showImage = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _initializeImage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(OptimizedImageHashPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _resetAndReload();
    }
  }

  void _resetAndReload() {
    setState(() {
      cachedImage = null;
      _showImage = false;
      _error = null;
    });
    _controller.reset();
    _initializeImage();
  }

  Future<void> _initializeImage() async {
    // Load hash first
    imageHashFuture = ImageHashManager.getImageHash(widget.imagePath);

    // Then load the actual image with configurable delay
    if (widget.hashLoadDelay > Duration.zero) {
      await Future.delayed(widget.hashLoadDelay);
    }
    await _preloadImage();
  }

  Future<void> _preloadImage() async {
    try {
      final imageData = await _fetchImage(widget.imagePath);
      final codec = await ui.instantiateImageCodec(imageData);
      final frame = await codec.getNextFrame();

      if (mounted) {
        setState(() {
          cachedImage = frame.image;
        });

        // Add configurable delay before showing the actual image
        if (widget.imageShowDelay > Duration.zero) {
          await Future.delayed(widget.imageShowDelay);
        }

        if (mounted) {
          setState(() {
            _showImage = true;
          });
          _controller.forward();
          widget.onLoaded?.call();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to preload image: $e');
      }
      if (mounted) {
        setState(() {
          _error = e;
        });
      }
    }
  }

  Future<Uint8List> _fetchImage(String url) async {
    final uri = Uri.parse(url);
    if (kIsWeb) {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      throw Exception(
        "Failed to load image from $url (Status: ${response.statusCode})",
      );
    } else {
      final request = await HttpClient().getUrl(uri);
      final response = await request.close();
      if (response.statusCode == 200) {
        return await consolidateHttpClientResponseBytes(response);
      }
      throw Exception(
        "Failed to load image from $url (Status: ${response.statusCode})",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error widget if error occurred
    if (_error != null && widget.errorBuilder != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: widget.errorBuilder!(context, _error!),
        ),
      );
    }

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            // BlurHash preview
            FutureBuilder<String?>(
              future: imageHashFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: BlurHash(
                      hash: snapshot.data!,
                      imageFit: widget.fit,
                      decodingWidth: widget.decodingWidth,
                      decodingHeight: widget.decodingHeight,
                    ),
                  );
                }
                return Container(
                  color: widget.placeholderColor ?? Colors.grey.shade300,
                );
              },
            ),
            // Actual image (when loaded)
            if (_showImage && cachedImage != null)
              FadeTransition(
                opacity: _controller,
                child: RawImage(
                  image: cachedImage,
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit,
                  filterQuality: widget.filterQuality,
                ),
              ),
            // Default error indicator if no custom errorBuilder
            if (_error != null && widget.errorBuilder == null)
              Container(
                color: widget.placeholderColor ?? Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.error_outline, color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
