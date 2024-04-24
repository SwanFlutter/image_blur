import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:image_blur/src/tools/get_image_tools.dart';

class ImageHashPreview extends StatefulWidget {
  const ImageHashPreview({
    Key? key,
    required this.imagePath,
    this.width,
    this.height,
    this.placeholderColor,
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
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  final String imagePath;

  final double? width;

  final double? height;

  final Color? placeholderColor;

  final Curve curve;

  final BoxFit fit;

  final int decodingHeight;

  final int decodingWidth;

  final Duration duration;

  final void Function()? onDecoded;

  final void Function()? onStarted;

  final void Function()? onReady;

  final void Function()? onDisplayed;

  final BlendMode? colorBlendMode;

  final Color? color;

  final Alignment alignment;

  final Rect? centerSlice;

  final Animation<double>? opacity;

  final FilterQuality filterQuality;

  final ImageRepeat repeat;

  final bool matchTextDirection;

  final bool gapLessPlayback;

  final String? semanticLabel;

  final ImageFrameBuilder? frameBuilder;

  final ImageLoadingBuilder? loadingBuilder;

  final ImageErrorWidgetBuilder? errorBuilder;

  final bool isAntiAlias;

  final Map<String, String>? headers;

  final int? cacheWidth;

  final int? cacheHeight;

  final double scale;

  final BorderRadiusGeometry borderRadius;

  @override
  _ImageHashPreviewState createState() => _ImageHashPreviewState();
}

class _ImageHashPreviewState extends State<ImageHashPreview> {
  late Future<String?> imageHashFuture;

  @override
  void initState() {
    super.initState();
    imageHashFuture = GetImage.getImageHash(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.placeholderColor ?? Colors.grey.shade300,
          borderRadius: widget.borderRadius,
        ),
        child: FutureBuilder<String?>(
          future: imageHashFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: widget.width,
                height: widget.height,
                color: widget.placeholderColor ?? Colors.grey.shade300,
              ); // Show loading indicator
            } else if (snapshot.hasData) {
              return Stack(
                children: [
                  Opacity(
                    opacity: 0.0, // Set opacity to 0 to hide the image
                    child: Image.network(
                      widget.imagePath,
                      width: widget.width,
                      height: widget.height,
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
              return Container(); // Or any default widget
            }
          },
        ),
      ),
    );
  }
}





/**import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:image_blur/src/tools/get_image_tools.dart';

class ImageHashPreview extends StatefulWidget {
  const ImageHashPreview({
    Key? key,
    required this.imagePath,
    this.width,
    this.height,
    this.placeholderColor,
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
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  final String imagePath;

  final double? width;

  final double? height;

  final Color? placeholderColor;

  final Curve curve;

  final BoxFit fit;

  final int decodingHeight;

  final int decodingWidth;

  final Duration duration;

  final void Function()? onDecoded;

  final void Function()? onStarted;

  final void Function()? onReady;

  final void Function()? onDisplayed;

  final BlendMode? colorBlendMode;

  final Color? color;

  final Alignment alignment;

  final Rect? centerSlice;

  final Animation<double>? opacity;

  final FilterQuality filterQuality;

  final ImageRepeat repeat;

  final bool matchTextDirection;

  final bool gapLessPlayback;

  final String? semanticLabel;

  final ImageFrameBuilder? frameBuilder;

  final ImageLoadingBuilder? loadingBuilder;

  final ImageErrorWidgetBuilder? errorBuilder;

  final bool isAntiAlias;

  final Map<String, String>? headers;

  final int? cacheWidth;

  final int? cacheHeight;

  final double scale;

  final BorderRadiusGeometry borderRadius;

  @override
  _ImageHashPreviewState createState() => _ImageHashPreviewState();
}

class _ImageHashPreviewState extends State<ImageHashPreview> {
  late Future<String?> imageHashFuture;

  @override
  void initState() {
    super.initState();
    imageHashFuture = GetImage.getImageHash(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.placeholderColor ?? Colors.grey.shade300,
          borderRadius: widget.borderRadius,
        ),
        child: FutureBuilder<String?>(
          future: imageHashFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: widget.width,
                height: widget.height,
                color: widget.placeholderColor ?? Colors.grey.shade300,
              ); // Show loading indicator
            } else if (snapshot.hasData) {
              return Stack(
                children: [
                  Opacity(
                    opacity: 0.0, // Set opacity to 0 to hide the image
                    child: Image.network(
                      widget.imagePath,
                      width: widget.width,
                      height: widget.height,
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
              return Container(); // Or any default widget
            }
          },
        ),
      ),
    );
  }
}
 */