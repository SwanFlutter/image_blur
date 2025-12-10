import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:image_blur/src/tools/image_hash_manager.dart';

/// A circular image widget that displays an image fetched from the provided [imagePath]
/// with an optional BlurHash preview while loading.
class ImageHashPreviewCircular extends StatefulWidget {
  /// [size]: The size of the circular image.
  final double size;

  /// [imagePath]: The URL or path of the image to be displayed.
  final String imagePath;

  /// [placeholderColor]: The color to be displayed as a placeholder while the image is loading.
  final Color? placeholderColor;

  /// [curve]: The animation curve used for transitioning the image.
  final Curve curve;

  /// [fit]: The fit of the image within the circular widget.
  final BoxFit fit;

  /// [decodingHeight]: The height used to decode the image.
  final int decodingHeight;

  /// [decodingWidth]: The width used to decode the image.
  final int decodingWidth;

  /// [duration]: The duration of the transition animation.
  final Duration duration;

  /// [onDecoded]: A callback function invoked when the image is decoded.
  final void Function()? onDecoded;

  /// [onStarted]: A callback function invoked when the image loading process starts.
  final void Function()? onStarted;

  /// [onReady]: A callback function invoked when the image is ready for display.
  final void Function()? onReady;

  /// [onDisplayed]: A callback function invoked when the image is displayed.
  final void Function()? onDisplayed;

  /// [colorBlendMode]: The blend mode used to blend the image with the background color.
  final BlendMode? colorBlendMode;

  /// [color]: The color applied as a filter to the image.
  final Color? color;

  /// [alignment]: The alignment of the image within its bounding box.
  final Alignment alignment;

  /// [centerSlice]: The rectangle inside the image used for centering and scaling.
  final Rect? centerSlice;

  /// [opacity]: The opacity of the image.
  final Animation<double>? opacity;

  /// [filterQuality] The quality of the image filtering.
  final FilterQuality filterQuality;

  /// [repeat]: The strategy to use when painting the image.
  final ImageRepeat repeat;

  /// [matchTextDirection]: Whether to match the direction of the image with the direction of the text.
  final bool matchTextDirection;

  /// [gapLessPlayback]: Whether to gaplessly loop a finite set of images.
  final bool gapLessPlayback;

  /// [semanticLabel]: A semantic description of the image.
  final String? semanticLabel;

  /// [frameBuilder]: A builder function used to create custom frames for the image.
  final ImageFrameBuilder? frameBuilder;

  /// [loadingBuilder]: A builder function used to create custom widgets while the image is loading.
  final ImageLoadingBuilder? loadingBuilder;

  /// [errorBuilder]: A builder function used to create custom error widgets.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// [isAntiAlias]: Whether to use anti-aliasing when painting the image.
  final bool isAntiAlias;

  /// [headers]: Optional HTTP headers to include in the image request.
  final Map<String, String>? headers;

  /// [cacheWidth]: The desired width of the image cache.

  final int? cacheWidth;

  /// [cacheHeight]: The desired height of the image cache.
  final int? cacheHeight;

  /// [scale]: The scale to apply to the image.
  final double scale;
  const ImageHashPreviewCircular({
    super.key,
    required this.imagePath,
    this.size = 50,
    this.placeholderColor = const Color.fromRGBO(224, 224, 224, 1),
    this.curve = Curves.easeOut,
    this.fit = BoxFit.cover,
    this.decodingHeight = 32,
    this.decodingWidth = 32,
    this.duration = const Duration(milliseconds: 1000),
    this.onDecoded,
    this.onStarted,
    this.onReady,
    this.onDisplayed,
    this.colorBlendMode = BlendMode.srcIn,
    this.color,
    this.alignment = Alignment.center,
    this.centerSlice,
    this.opacity,
    this.filterQuality = FilterQuality.low,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.gapLessPlayback = false,
    this.semanticLabel,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.isAntiAlias = false,
    this.headers,
    this.cacheWidth,
    this.cacheHeight,
    this.scale = 1.0,
  });

  @override
  State<ImageHashPreviewCircular> createState() =>
      _ImageHashPreviewCircularState();
}

class _ImageHashPreviewCircularState extends State<ImageHashPreviewCircular> {
  late Future<String?> imageHashFuture;

  @override
  void initState() {
    super.initState();
    imageHashFuture = ImageHashManager.getImageHash(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.placeholderColor,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: FutureBuilder<String?>(
          future: imageHashFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: widget.size,
                height: widget.size,
                color: Colors.grey.shade300,
              ); // Show loading indicator
            } else if (snapshot.hasData) {
              return Stack(
                children: [
                  Opacity(
                    opacity: 0.0, // Set opacity to 0 to hide the image
                    child: Image.network(
                      widget.imagePath,
                      width: widget.size,
                      height: widget.size,
                      fit: widget.fit,
                      colorBlendMode: widget.colorBlendMode,
                      color: widget.color,
                      alignment: widget.alignment,
                      centerSlice: widget.centerSlice,
                      opacity: widget.opacity,
                      filterQuality: widget.filterQuality,
                      repeat: widget.repeat,
                      matchTextDirection: widget.matchTextDirection,
                      gaplessPlayback: widget.gapLessPlayback,
                      semanticLabel: widget.semanticLabel,
                      frameBuilder: widget.frameBuilder,
                      loadingBuilder: widget.loadingBuilder,
                      errorBuilder: widget.errorBuilder,
                      isAntiAlias: widget.isAntiAlias,
                      headers: widget.headers,
                      cacheWidth: widget.cacheWidth,
                      cacheHeight: widget.cacheHeight,
                      scale: widget.scale,
                    ),
                  ),
                  BlurHash(
                    color: Colors.transparent,
                    hash: snapshot.data!, // Access the extracted String
                    image: widget.imagePath,
                    imageFit: widget.fit,
                    curve: widget.curve,
                    decodingHeight: widget.decodingHeight,
                    decodingWidth: widget.decodingWidth,
                    duration: widget.duration,
                    onDecoded: widget.onDecoded,
                    onStarted: widget.onStarted,
                    onDisplayed: widget.onDisplayed,
                    onReady: widget.onReady,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Handle errors
            } else {
              return const SizedBox(); // Or any default widget
            }
          },
        ),
      ),
    );
  }
}
