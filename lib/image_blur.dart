import 'dart:ui';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_blur/src/tools/get_image_tools.dart';
import 'package:image_blur/src/widget/image_circular_blur.dart';
import 'package:image_blur/src/widget/image_hash_preview.dart';
import 'package:image_blur/src/widget/image_hash_preview_circular.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageBlur extends StatefulWidget {
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
  final Future<PaletteGenerator?>? Function(Future<PaletteGenerator>?)?
      onPaletteReceived;

  const ImageBlur({
    required this.imageUrl,
    Key? key,
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

  static Widget imageCircularBlur({
    /// Receives images from Image Network
    Key? key,

    ///Receives images from Image Network
    final String? imageNetwork,

    ///Receives images locally
    final String? imageAssets,

    ///Specifies how long to wait and display the durationShimmer. Default = 3
    int durationShimmer = 3,

    ///Specifies how long to wait and display the durationBlur. Default = 2
    int durationBlur = 2,

    ///If non-null, requires the child to have exactly this height. Default = 100
    double? size,

    ///Default [BoxFit.cover]
    BoxFit? fit = BoxFit.cover,

    ///Used to combine [color] with this image.
    ///The default is [BlendMode.srcIn]. In terms of the blend mode, [color] is the source and this image is the destination.
    ///See also:
    ///[BlendMode], which includes an illustration of the effect of each blend mode.
    BlendMode? colorBlendMode = BlendMode.srcIn,

    ///If non-null, this color is blended with each image pixel using [colorBlendMode].

    Color? color,

    /// How to align the image within its bounds.

    ///The alignment aligns the given position in the image to the given position in the layout bounds. For example, an [Alignment] alignment of (-1.0, -1.0) aligns the image to the top-left corner of its layout bounds, while an [Alignment] alignment of (1.0, 1.0) aligns the bottom right of the image with the bottom right corner of its layout bounds. Similarly, an alignment of (0.0, 1.0) aligns the bottom middle of the image with the middle of the bottom edge of its layout bounds.

    ///To display a subpart of an image, consider using a [CustomPainter] and [Canvas.drawImageRect].

    ///If the [alignment] is [TextDirection]-dependent (i.e. if it is a [AlignmentDirectional]), then an ambient [Directionality] widget must be in scope.

    ///Defaults to [Alignment.center].

//See also:

    ///[Alignment], a class with convenient constants typically used to specify an [AlignmentGeometry].
    ///[AlignmentDirectional], like [Alignment] for specifying alignments relative to text direction.
    AlignmentGeometry alignment = Alignment.center,

    ///The center slice for a nine-patch image.

    ///The region of the image inside the center slice will be stretched both horizontally and vertically to fit the image into its destination. The region of the image above and below the center slice will be stretched only horizontally and the region of the image to the left and right of the center slice will be stretched only vertically.
    Rect? centerSlice,

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
    Animation<double>? opacity,

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
    FilterQuality filterQuality = FilterQuality.low,

    /// How to paint any portions of the layout bounds not covered by the image.
    ImageRepeat repeat = ImageRepeat.noRepeat,

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
    bool matchTextDirection = false,

    /// Whether to continue showing the old image (true), or briefly show nothing
    /// (false), when the image provider changes. The default value is false.
    ///
    /// ## Design discussion
    ///
    /// ### Why is the default value of [gaplessPlayback] false?
    ///
    /// Having the default value of [gaplessPlayback] be false helps prevent
    /// situations where stale or misleading information might be presented.
    /// Consider the following case:
    ///
    /// We have constructed a 'Person' widget that displays an avatar [Image] of
    /// the currently loaded person along with their name. We could request for a
    /// new person to be loaded into the widget at any time. Suppose we have a
    /// person currently loaded and the widget loads a new person. What happens
    /// if the [Image] fails to load?
    ///
    /// * Option A ([gaplessPlayback] = false): The new person's name is coupled
    /// with a blank image.
    ///
    /// * Option B ([gaplessPlayback] = true): The widget displays the avatar of
    /// the previous person and the name of the newly loaded person.
    ///
    /// This is why the default value is false. Most of the time, when you change
    /// the image provider you're not just changing the image, you're removing the
    /// old widget and adding a new one and not expecting them to have any
    /// relationship. With [gaplessPlayback] on you might accidentally break this
    /// expectation and re-use the old widget.
    bool gapLessPlayback = false,

    /// A Semantic description of the image.
    ///
    /// Used to provide a description of the image to TalkBack on Android, and
    /// VoiceOver on iOS.
    String? semanticLabel,

    /// A builder function responsible for creating the widget that represents
    /// this image.
    ///
    /// If this is null, this widget will display an image that is painted as
    /// soon as the first image frame is available (and will appear to "pop" in
    /// if it becomes available asynchronously). Callers might use this builder to
    /// add effects to the image (such as fading the image in when it becomes
    /// available) or to display a placeholder widget while the image is loading.
    ///
    /// To have finer-grained control over the way that an image's loading
    /// progress is communicated to the user, see [loadingBuilder].
    ///
    /// ## Chaining with [loadingBuilder]
    ///
    /// If a [loadingBuilder] has _also_ been specified for an image, the two
    /// builders will be chained together: the _result_ of this builder will
    /// be passed as the `child` argument to the [loadingBuilder]. For example,
    /// consider the following builders used in conjunction:
    ///
    /// {@template flutter.widgets.Image.frameBuilder.chainedBuildersExample}
    /// ```dart
    /// Image(
    ///   image: _image,
    ///   frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
    ///     return Padding(
    ///       padding: const EdgeInsets.all(8.0),
    ///       child: child,
    ///     );
    ///   },
    ///   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    ///     return Center(child: child);
    ///   },
    /// )
    /// ```
    ///
    /// In this example, the widget hierarchy will contain the following:
    ///
    /// ```dart
    /// Center(
    ///   child: Padding(
    ///     padding: const EdgeInsets.all(8.0),
    ///     child: image,
    ///   ),
    /// ),
    /// ```
    /// {@endtemplate}
    ///
    /// {@tool dartpad}
    /// The following sample demonstrates how to use this builder to implement an
    /// image that fades in once it's been loaded.
    ///
    /// This sample contains a limited subset of the functionality that the
    /// [FadeInImage] widget provides out of the box.
    ///
    /// ** See code in examples/api/lib/widgets/image/image.frame_builder.0.dart **
    /// {@end-tool}
    ImageFrameBuilder? frameBuilder,

    /// A builder that specifies the widget to display to the user while an image
    /// is still loading.
    ///
    /// If this is null, and the image is loaded incrementally (e.g. over a
    /// network), the user will receive no indication of the progress as the
    /// bytes of the image are loaded.
    ///
    /// For more information on how to interpret the arguments that are passed to
    /// this builder, see the documentation on [ImageLoadingBuilder].
    ///
    /// ## Performance implications
    ///
    /// If a [loadingBuilder] is specified for an image, the [Image] widget is
    /// likely to be rebuilt on every
    /// [rendering pipeline frame](rendering/RendererBinding/drawFrame.html) until
    /// the image has loaded. This is useful for cases such as displaying a loading
    /// progress indicator, but for simpler cases such as displaying a placeholder
    /// widget that doesn't depend on the loading progress (e.g. static "loading"
    /// text), [frameBuilder] will likely work and not incur as much cost.
    ///
    /// ## Chaining with [frameBuilder]
    ///
    /// If a [frameBuilder] has _also_ been specified for an image, the two
    /// builders will be chained together: the `child` argument to this
    /// builder will contain the _result_ of the [frameBuilder]. For example,
    /// consider the following builders used in conjunction:
    ///
    /// {@macro flutter.widgets.Image.frameBuilder.chainedBuildersExample}
    ///
    /// {@tool dartpad}
    /// The following sample uses [loadingBuilder] to show a
    /// [CircularProgressIndicator] while an image loads over the network.
    ///
    /// ** See code in examples/api/lib/widgets/image/image.loading_builder.0.dart **
    /// {@end-tool}
    ///
    /// Run against a real-world image on a slow network, the previous example
    /// renders the following loading progress indicator while the image loads
    /// before rendering the completed image.
    ///
    /// {@animation 400 400 https://flutter.github.io/assets-for-api-docs/assets/widgets/loading_progress_image.mp4}
    ImageLoadingBuilder? loadingBuilder,

    /// A builder function that is called if an error occurs during image loading.
    ///
    /// If this builder is not provided, any exceptions will be reported to
    /// [FlutterError.onError]. If it is provided, the caller should either handle
    /// the exception by providing a replacement widget, or rethrow the exception.
    ///
    /// {@tool dartpad}
    /// The following sample uses [errorBuilder] to show a '😢' in place of the
    /// image that fails to load, and prints the error to the console.
    ///
    /// ** See code in examples/api/lib/widgets/image/image.error_builder.0.dart **
    /// {@end-tool}
    ImageErrorWidgetBuilder? errorBuilder,

    /// Whether to paint the image with anti-aliasing.

    /// Anti-aliasing alleviates the sawtooth artifact when the image is rotated.
    bool isAntiAlias = false,

    /// [isBlur]: Flag indicating whether to generate BlurHash representations for images.
    bool isBlur = true,

    /// [isShimmer]: Flag indicating whether to display a shimmer effect while loading images.
    bool isShimmer = true,

    /// [headers]: A map from request headers to values for the request.
    Map<String, String>? headers,

    /// [cacheWidth]: The desired width of the image cache.
    int? cacheWidth,

    /// [cacheHeight]: The desired height of the image cache.
    int? cacheHeight,
  }) {
    return ImageCircularBlur(
      imageAssets: imageAssets,
      imageNetwork: imageNetwork,
      size: size,
      fit: fit,
      colorBlendMode: colorBlendMode,
      color: color,
      alignment: alignment,
      centerSlice: centerSlice,
      opacity: opacity,
      filterQuality: filterQuality,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      gapLessPlayback: gapLessPlayback,
      semanticLabel: semanticLabel,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      isAntiAlias: isAntiAlias,
      isBlur: isBlur,
      isShimmer: isShimmer,
      cacheHeight: cacheHeight,
      cacheWidth: cacheWidth,
      headers: headers,
      key: key,
    );
  }

  static Widget imageHashPreview({
    required final String imagePath,
    final double? width,
    final double? height,
    final Color? placeholderColor = const Color.fromRGBO(224, 224, 224, 1),
    final Curve curve = Curves.easeOut,
    final BoxFit fit = BoxFit.cover,
    final int decodingHeight = 32,
    final int decodingWidth = 32,
    final Duration duration = const Duration(milliseconds: 1000),
    final void Function()? onDecoded,
    final void Function()? onStarted,
    final void Function()? onReady,
    final void Function()? onDisplayed,
    final BlendMode? colorBlendMode,
    final Color? color,
    final Alignment alignment = Alignment.center,
    final Rect? centerSlice,
    final Animation<double>? opacity,
    final FilterQuality filterQuality = FilterQuality.low,
    final ImageRepeat repeat = ImageRepeat.noRepeat,
    final bool matchTextDirection = false,
    final bool gapLessPlayback = false,
    final String? semanticLabel,
    final ImageFrameBuilder? frameBuilder,
    final ImageLoadingBuilder? loadingBuilder,
    final ImageErrorWidgetBuilder? errorBuilder,
    final bool isAntiAlias = false,
    final Map<String, String>? headers,
    final int? cacheWidth,
    final int? cacheHeight,
    final double scale = 1.0,
    final BorderRadiusGeometry borderRadius = BorderRadius.zero,
    final Future<PaletteGenerator?>? Function(Future<PaletteGenerator>?)?
        onPaletteReceived,
    Key? key,
  }) {
    return ImageHashPreview(
      imagePath: imagePath,
      width: width,
      height: height,
      placeholderColor: placeholderColor,
      curve: curve,
      fit: fit,
      decodingHeight: decodingHeight,
      decodingWidth: decodingWidth,
      duration: duration,
      onDecoded: onDecoded,
      onReady: onReady,
      onStarted: onStarted,
      onDisplayed: onDisplayed,
      colorBlendMode: colorBlendMode,
      color: color,
      alignment: alignment,
      centerSlice: centerSlice,
      opacity: opacity,
      filterQuality: filterQuality,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      gapLessPlayback: gapLessPlayback,
      semanticLabel: semanticLabel,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      isAntiAlias: isAntiAlias,
      headers: headers,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      scale: scale,
      borderRadius: borderRadius,
      onPaletteReceived: onPaletteReceived,
      key: key,
    );
  }

  static Widget imageHashPreviewCircular({
    required final String imagePath,
    final double size = 50.0,
    final Color? placeholderColor,
    final Curve curve = Curves.easeOut,
    final BoxFit fit = BoxFit.cover,
    final int decodingHeight = 32,
    final int decodingWidth = 32,
    final Duration duration = const Duration(milliseconds: 1000),
    final void Function()? onDecoded,
    final void Function()? onStarted,
    final void Function()? onReady,
    final void Function()? onDisplayed,
    final BlendMode? colorBlendMode,
    final Color? color,
    final Alignment alignment = Alignment.center,
    final Rect? centerSlice,
    final Animation<double>? opacity,
    final FilterQuality filterQuality = FilterQuality.low,
    final ImageRepeat repeat = ImageRepeat.noRepeat,
    final bool matchTextDirection = false,
    final bool gapLessPlayback = false,
    final String? semanticLabel,
    final ImageFrameBuilder? frameBuilder,
    final ImageLoadingBuilder? loadingBuilder,
    final ImageErrorWidgetBuilder? errorBuilder,
    final bool isAntiAlias = false,
    final Map<String, String>? headers,
    final int? cacheWidth,
    final int? cacheHeight,
    final double scale = 1.0,
    Key? key,
  }) {
    return ImageHashPreviewCircular(
      imagePath: imagePath,
      size: size,
      placeholderColor: placeholderColor,
      curve: curve,
      fit: fit,
      decodingHeight: decodingHeight,
      decodingWidth: decodingWidth,
      duration: duration,
      onDecoded: onDecoded,
      onReady: onReady,
      onStarted: onStarted,
      onDisplayed: onDisplayed,
      colorBlendMode: colorBlendMode,
      color: color,
      alignment: alignment,
      centerSlice: centerSlice,
      opacity: opacity,
      filterQuality: filterQuality,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      gapLessPlayback: gapLessPlayback,
      semanticLabel: semanticLabel,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      isAntiAlias: isAntiAlias,
      headers: headers,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      scale: scale,
      key: key,
    );
  }

  @override
  State<ImageBlur> createState() => _ImageBlurState();
  static ImageBlur instance() => ImageBlur(
        imageUrl: '',
      );
  static Future<void> init({int removeCacheTime = 30}) async {
    await FastCachedImageConfig.init(
      clearCacheAfter: Duration(minutes: removeCacheTime),
    );
  }
}

class _ImageBlurState extends State<ImageBlur> {
  @override
  void initState() {
    GetImage.fetchImageAndGeneratePalette(widget.imageUrl).then((value) {
      widget.onPaletteReceived?.call(Future.value(value));
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double blurValue = 0.0;
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
              double progressValue = (downloadProgress.downloadedBytes /
                      downloadProgress.totalBytes!) *
                  25;

              blurValue = 25 - progressValue;
              return ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: blurValue,
                  sigmaY: blurValue,
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
