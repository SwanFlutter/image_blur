import 'dart:ui';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_blur/src/tools/get_image_tools.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

class ImageBlurGetPalletteColor extends StatefulWidget {
  /// [imageUrl] The path or URL of the image to be displayed.
  final String imageUrl;

  ///Default [BoxFit.cover]
  final BoxFit? fit;

  /// [height] non-null, requires the child to have exactly this height.
  final double? height;

  /// [width] non-null, requires the child to have exactly this width.
  final double? width;

  ///Used to combine [color] with this image.
  ///The default is [BlendMode.srcIn]. In terms of the blend mode, [color] is the source and this image is the destination.
  ///See also:
  ///[BlendMode], which includes an illustration of the effect of each blend mode.
  final BlendMode? colorBlendMode;

  ///If non-null, this color is blended with each image pixel using [colorBlendMode].
  final Color? color;

  /// How to align the image within its bounds.

  ///The alignment aligns the given position in the image to the given position in the layout bounds. For example, an [Alignment] alignment of (-1.0, -1.0) aligns the image to the top-left corner of its layout bounds, while an [Alignment] alignment of (1.0, 1.0) aligns the bottom right of the image with the bottom right corner of its layout bounds. Similarly, an alignment of (0.0, 1.0) aligns the bottom middle of the image with the middle of the bottom edge of its layout bounds.

  ///To display a subpart of an image, consider using a [CustomPainter] and [Canvas.drawImageRect].

  ///If the [alignment] is [TextDirection]-dependent (i.e. if it is a [AlignmentDirectional]), then an ambient [Directionality] widget must be in scope.

  ///Defaults to [Alignment.center].

  //See also:

  ///[Alignment], a class with convenient constants typically used to specify an [AlignmentGeometry].
  ///[AlignmentDirectional], like [Alignment] for specifying alignments relative to text direction.
  final Alignment alignment;

  ///The center slice for a nine-patch image.
  final Rect? centerSlice;

  /// If non-null, the value from the [Animation] is multiplied with the opacity
  /// of each image pixel before painting onto the canvas.
  ///
  /// This is more efficient than using [FadeTransition] to change the opacity
  /// of an image, since this avoids creating a new composited layer. Composited
  /// layers may double memory usage as the image is painted onto an offscreen
  /// render target.
  ///
  /// See also:
  ///
  ///  * [AlwaysStoppedAnimation], which allows you to create an [Animation]
  ///    from a single opacity value.
  final Animation<double>? opacity;

  /// The rendering quality of the image.
  ///
  /// {@template flutter.widgets.image.filterQuality}
  /// If the image is of a high quality and its pixels are perfectly aligned
  /// with the physical screen pixels, extra quality enhancement may not be
  /// necessary. If so, then [FilterQuality.none] would be the most efficient.
  ///
  /// If the pixels are not perfectly aligned with the screen pixels, or if the
  /// image itself is of a low quality, [FilterQuality.none] may produce
  /// undesirable artifacts. Consider using other [FilterQuality] values to
  /// improve the rendered image quality in this case. Pixels may be misaligned
  /// with the screen pixels as a result of transforms or scaling.
  ///
  /// See also:
  ///
  ///  * [FilterQuality], the enum containing all possible filter quality
  ///    options.
  /// {@endtemplate}
  final FilterQuality filterQuality;

  ///How to paint any portions of the layout bounds not covered by the image.
  final ImageRepeat repeat;

  /// Whether to paint the image in the direction of the [TextDirection].
  ///
  /// If this is true, then in [TextDirection.ltr] contexts, the image will be
  /// drawn with its origin in the top left (the "normal" painting direction for
  /// images); and in [TextDirection.rtl] contexts, the image will be drawn with
  /// a scaling factor of -1 in the horizontal direction so that the origin is
  /// in the top right.
  ///
  /// This is occasionally used with images in right-to-left environments, for
  /// images that were designed for left-to-right locales. Be careful, when
  /// using this, to not flip images with integral shadows, text, or other
  /// effects that will look incorrect when flipped.
  ///
  /// If this is true, there must be an ambient [Directionality] widget in
  /// scope.
  final bool matchTextDirection;

  /// Whether the image should be played in the background when it's not visible.
  final bool gapLessPlayback;

  /// The semantic label for this image.
  final String? semanticLabel;

  /// A builder function that is called if an error occurs during image loading.
  final ImageFrameBuilder? frameBuilder;

  /// A builder function that is called if an error occurs during image loading.
  final ImageLoadingBuilder? loadingBuilder;

  /// A builder function that is called if an error occurs during image loading.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// Whether to paint the image with anti-aliasing.
  final bool isAntiAlias;

  /// The headers used for http requests.
  final Map<String, String>? headers;

  /// The width and height of the image in logical pixels.
  final int? cacheWidth;

  /// The width and height of the image in logical pixels.
  final int? cacheHeight;

  /// The color to use when drawing the image.
  final TileMode tileMode;

  /// The duration of the fade-in effect.
  final Duration fadeInDuration;

  ///The color of the placeholder image.
  final Color backgroundImage;

  /// The height and width of the image in logical pixels.
  final double scale;

  /// The height and width of the image in logical pixels.
  final int? memCacheHeight;

  /// The height and width of the image in logical pixels.
  final int? memCacheWidth;

  ///The color of the placeholder image.
  final Color? placeholderColor;

  ///If non-null, the corners of this box are rounded by this [BorderRadius].
  ///Applies only to boxes with rectangular shapes; ignored if [shape] is not [BoxShape.rectangle].
  ///The [shape] or the [borderRadius] won't clip the children of the decorated [Container].
  /// If the clip is required, insert a clip widget (e.g., [ClipRect], [ClipRRect], [ClipPath]) as the child of the [Container].
  ///  Be aware that clipping may be costly in terms of performance.
  final BorderRadiusGeometry borderRadius;

  /// Fetches the image and generates the palette color
  final Future<PaletteGeneratorMaster?>? Function(
    Future<PaletteGeneratorMaster>?,
  )?
  onPaletteReceived;
  const ImageBlurGetPalletteColor({
    required this.imageUrl,
    super.key,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
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
    this.tileMode = TileMode.decal,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.backgroundImage = const Color.fromRGBO(238, 238, 238, 1),
    this.scale = 1.0,
    this.memCacheHeight,
    this.memCacheWidth,
    this.placeholderColor = const Color.fromRGBO(224, 224, 224, 1),
    this.borderRadius = BorderRadius.zero,
    this.onPaletteReceived,
  });

  @override
  State<ImageBlurGetPalletteColor> createState() =>
      _ImageBlurGetPalletteColorState();
}

class _ImageBlurGetPalletteColorState extends State<ImageBlurGetPalletteColor> {
  double _blurValue = 25.0;

  @override
  void initState() {
    super.initState();
    GetImage.fetchImageAndGeneratePalette(widget.imageUrl).then((value) {
      if (mounted) {
        widget.onPaletteReceived?.call(Future.value(value));
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.placeholderColor,
        borderRadius: widget.borderRadius,
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: FastCachedImage(
          errorBuilder: (context, url, error) => const Icon(Icons.error),
          url: widget.imageUrl,
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
          cacheHeight: widget.memCacheHeight,
          cacheWidth: widget.memCacheWidth,
          loadingBuilder: (context, downloadProgress) {
            if (downloadProgress.totalBytes != null &&
                downloadProgress.totalBytes! > 0) {
              final double progressValue =
                  (downloadProgress.downloadedBytes /
                      downloadProgress.totalBytes!) *
                  25;

              final double newBlurValue = 25 - progressValue;
              if (newBlurValue != _blurValue) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _blurValue = newBlurValue;
                    });
                  }
                });
              }
              return ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: _blurValue,
                  sigmaY: _blurValue,
                  tileMode: TileMode.decal,
                ),
                child: Image.network(
                  widget.imageUrl,
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit,
                  colorBlendMode: widget.colorBlendMode,
                  color: widget.color,
                  alignment: widget.alignment,
                  centerSlice: widget.centerSlice,
                  errorBuilder: widget.errorBuilder,
                  filterQuality: widget.filterQuality,
                  gaplessPlayback: widget.gapLessPlayback,
                  isAntiAlias: widget.isAntiAlias,
                  opacity: widget.opacity,
                  semanticLabel: widget.semanticLabel,
                  repeat: widget.repeat,
                  matchTextDirection: widget.matchTextDirection,
                  cacheHeight: widget.cacheHeight,
                  cacheWidth: widget.cacheWidth,
                  frameBuilder: widget.frameBuilder,
                  scale: widget.scale,
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
