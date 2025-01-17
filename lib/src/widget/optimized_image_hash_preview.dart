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

  /// Creates an [OptimizedImageHashPreview] widget.
  const OptimizedImageHashPreview({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderColor,
    this.borderRadius = BorderRadius.zero,
    this.duration = const Duration(milliseconds: 1000),
    this.onLoaded,
  });

  @override
  _OptimizedImageHashPreviewState createState() =>
      _OptimizedImageHashPreviewState();
}

class _OptimizedImageHashPreviewState extends State<OptimizedImageHashPreview>
    with SingleTickerProviderStateMixin {
  late Future<String?> imageHashFuture;
  ui.Image? cachedImage;
  late AnimationController _controller;
  bool _showImage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _initializeImage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeImage() async {
    // Load hash first
    imageHashFuture = ImageHashManager.getImageHash(widget.imagePath);

    // Then load the actual image with a slight delay
    await Future.delayed(const Duration(milliseconds: 500));
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

        // Add a small delay before showing the actual image
        await Future.delayed(const Duration(milliseconds: 1000));

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
    }
  }

  Future<Uint8List> _fetchImage(String url) async {
    final uri = Uri.parse(url);
    if (kIsWeb) {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      throw Exception("Failed to load image from $url");
    } else {
      final request = await HttpClient().getUrl(uri);
      final response = await request.close();
      if (response.statusCode == 200) {
        return await consolidateHttpClientResponseBytes(response);
      }
      throw Exception("Failed to load image from $url");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      decodingWidth: 32,
                      decodingHeight: 32,
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
                  filterQuality: FilterQuality.high,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
