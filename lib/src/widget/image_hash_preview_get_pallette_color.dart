import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:image_blur/src/tools/get_image_tools.dart';
import 'package:image_blur/src/tools/image_hash_manager.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

class ImageHashGetPaletteColor extends StatefulWidget {
  /// [imagePath] The path or URL of the image to be displayed.
  final String imagePath;

  /// [width] The width of the image widget.
  final double? width;

  /// [height] The height of the image widget.
  final double? height;

  /// [placeholderColor] The color to display as a placeholder while the image is loading.
  final Color? placeholderColor;

  /// [] The curve used for animation transitions.
  final Curve curve;

  /// [fit] How the image should be inscribed into the space allocated during layout.
  final BoxFit fit;

  /// [decodingHeight] The height used to decode the image.
  final int decodingHeight;

  /// [decodingWidth] The width used to decode the image.
  final int decodingWidth;

  /// [duration] The duration of the transition animation.
  final Duration duration;

  /// [onDecoded] A callback function invoked when the image is decoded.
  final void Function()? onDecoded;

  /// [onStarted] A callback function invoked when the image loading process starts.
  final void Function()? onStarted;

  /// [onReady] A callback function invoked when the image is ready for display.
  final void Function()? onReady;

  /// [onDisplayed] A callback function invoked when the image is displayed.
  final void Function()? onDisplayed;

  /// [colorBlendMode] The blend mode used to blend the image with the background color.
  final BlendMode? colorBlendMode;

  /// [color] The color applied as a filter to the image.
  final Color? color;

  /// [alignment] The alignment of the image within its bounding box.
  final Alignment alignment;

  /// [centerSlice] The rectangle inside the image used for centering and scaling.
  final Rect? centerSlice;

  /// [opacity] The opacity of the image.
  final Animation<double>? opacity;

  /// [filterQuality] The quality of the image filtering.
  final FilterQuality filterQuality;

  /// [repeat] The strategy to use when painting the image.
  final ImageRepeat repeat;

  /// [matchTextDirection] Whether to match the direction of the image with the direction of the text.
  final bool matchTextDirection;

  /// [gapLessPlayback] Whether to gaplessly loop a finite set of images.
  final bool gapLessPlayback;

  /// [semanticLabel] A semantic description of the image.
  final String? semanticLabel;

  /// [frameBuilder] A builder function used to create custom frames for the image.
  final ImageFrameBuilder? frameBuilder;

  /// [loadingBuilder] A builder function used to create custom widgets while the image is loading.
  final ImageLoadingBuilder? loadingBuilder;

  /// [errorBuilder] A builder function used to create custom error widgets.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// [isAntiAlias] Whether to use anti-aliasing when painting the image.
  final bool isAntiAlias;

  /// [headers] Optional HTTP headers to include in the image request.
  final Map<String, String>? headers;

  /// [cacheWidth] The desired width of the image cache.
  final int? cacheWidth;

  /// [cacheHeight] The desired height of the image cache.
  final int? cacheHeight;

  /// [scale] The scale to apply to the image.
  final double scale;

  /// [borderRadius] The border radius of the image widget.
  final BorderRadiusGeometry borderRadius;

  /// Fetches the image and generates the palette color
  final Future<PaletteGeneratorMaster?>? Function(
    Future<PaletteGeneratorMaster>?,
  )?
  onPaletteReceived;
  const ImageHashGetPaletteColor({
    super.key,
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
    this.onPaletteReceived,
  });

  @override
  State<ImageHashGetPaletteColor> createState() =>
      _ImageHashGetPaletteColorState();
}

class _ImageHashGetPaletteColorState extends State<ImageHashGetPaletteColor>
    with AutomaticKeepAliveClientMixin {
  late Future<String?> imageHashFuture;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _validateInputs();
    _initializeImage();
  }

  void _validateInputs() {
    assert(widget.decodingWidth > 0, 'decodingWidth must be positive');
    assert(widget.decodingHeight > 0, 'decodingHeight must be positive');
    assert(widget.scale > 0, 'scale must be positive');
  }

  void _initializeImage() {
    imageHashFuture = ImageHashManager.getImageHash(widget.imagePath);
    _fetchPalette();
  }

  Future<void> _fetchPalette() async {
    if (!mounted) return;

    final palette = await GetImage.fetchImageAndGeneratePalette(
      widget.imagePath,
    );
    if (!_disposed && mounted) {
      widget.onPaletteReceived?.call(Future.value(palette));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: FutureBuilder<String?>(
        future: imageHashFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingWidget();
          } else if (snapshot.hasData && snapshot.data != null) {
            return Stack(
              children: [_buildHiddenImage(), _buildBlurHash(snapshot.data!)],
            );
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          } else {
            return _buildErrorWidget('Failed to load image');
          }
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.placeholderColor ?? Colors.grey.shade300,
        borderRadius: widget.borderRadius,
      ),
    );
  }

  Widget _buildHiddenImage() {
    return Opacity(
      opacity: 0.0,
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
    );
  }

  Widget _buildBlurHash(String hash) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: BlurHash(
        color: Colors.transparent,
        hash: hash,
        image: widget.imagePath,
        imageFit: widget.fit,
        curve: widget.curve,
        decodingHeight: widget.decodingHeight,
        decodingWidth: widget.decodingWidth,
        duration: widget.duration,
        onDecoded: () {
          if (!_disposed) {
            widget.onDecoded?.call();
          }
        },
        onStarted: () {
          if (!_disposed) {
            widget.onStarted?.call();
          }
        },
        onDisplayed: () {
          if (!_disposed) {
            widget.onDisplayed?.call();
          }
        },
        onReady: () {
          if (!_disposed) {
            widget.onReady?.call();
          }
        },
      ),
    );
  }

  Widget _buildErrorWidget(Object? error) {
    return Container(
      width: widget.width,
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: widget.borderRadius,
      ),
      alignment: Alignment.center,
      child:
          widget.errorBuilder?.call(
            context,
            error ?? 'Failed to load image',
            null,
          ) ??
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.grey.shade400, size: 24),
              const SizedBox(height: 8),
              Text(
                'Image not available',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
