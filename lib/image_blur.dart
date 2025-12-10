import 'dart:ui';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_blur/src/widget/image_blur_get_pallette_color.dart';
import 'package:image_blur/src/widget/image_circular_blur.dart';
import 'package:image_blur/src/widget/image_hash_preview.dart';
import 'package:image_blur/src/widget/image_hash_preview_circular.dart';
import 'package:image_blur/src/widget/image_hash_preview_get_pallette_color.dart';
import 'package:image_blur/src/widget/image_hash_web.dart';
import 'package:image_blur/src/widget/optimized_image_hash_preview.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

export 'package:image_blur/src/tools/image_hash_manager.dart';
export 'package:image_blur_web/image_blur_web.dart';

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

  const ImageBlur({
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
    /// [imagePath] The path or URL of the image to be displayed.
    required final String imagePath,

    /// [width] The width of the image widget.
    final double? width,

    /// [height] The height of the image widget.
    final double? height,

    /// [placeholderColor] The color to display as a placeholder while the image is loading.
    final Color? placeholderColor = const Color.fromRGBO(224, 224, 224, 1),

    /// [curve] The curve used for animation transitions.
    final Curve curve = Curves.easeOut,

    /// [fit] How the image should be inscribed into the space allocated during layout.
    final BoxFit fit = BoxFit.cover,

    /// [decodingHeight] The height used to decode the image.
    final int decodingHeight = 32,

    /// [decodingWidth] The width used to decode the image.
    final int decodingWidth = 32,

    /// [duration] The duration of the transition animation.
    final Duration duration = const Duration(milliseconds: 1000),

    /// [onDecoded] A callback function invoked when the image is decoded.
    final void Function()? onDecoded,

    /// [onStarted] A callback function invoked when the image loading process starts.
    final void Function()? onStarted,

    /// [onReady] A callback function invoked when the image is ready for display.
    final void Function()? onReady,

    /// [onDisplayed] A callback function invoked when the image is displayed.
    final void Function()? onDisplayed,

    /// [colorBlendMode] The blend mode used to blend the image with the background color.
    final BlendMode? colorBlendMode,

    /// [color] The color applied as a filter to the image.
    final Color? color,

    /// [alignment] The alignment of the image within its bounding box.
    final Alignment alignment = Alignment.center,

    /// [centerSlice] The rectangle inside the image used for centering and scaling.
    final Rect? centerSlice,

    /// [opacity] The opacity of the image.
    final Animation<double>? opacity,

    /// [filterQuality] The quality of the image filtering.
    final FilterQuality filterQuality = FilterQuality.low,

    /// [repeat] The strategy to use when painting the image.
    final ImageRepeat repeat = ImageRepeat.noRepeat,

    /// [matchTextDirection] Whether to match the direction of the image with the direction of the text.
    final bool matchTextDirection = false,

    /// [gapLessPlayback] Whether to gaplessly loop a finite set of images.
    final bool gapLessPlayback = false,

    /// [semanticLabel] A semantic description of the image.
    final String? semanticLabel,

    /// [frameBuilder] A builder function used to create custom frames for the image.
    final ImageFrameBuilder? frameBuilder,

    /// [loadingBuilder] A builder function used to create custom widgets while the image is loading.
    final ImageLoadingBuilder? loadingBuilder,

    /// [errorBuilder] A builder function used to create custom error widgets.
    final ImageErrorWidgetBuilder? errorBuilder,

    /// [isAntiAlias] Whether to use anti-aliasing when painting the image.
    final bool isAntiAlias = false,

    /// [headers] Optional HTTP headers to include in the image request.
    final Map<String, String>? headers,

    /// [cacheWidth] The desired width of the image cache.
    final int? cacheWidth,

    /// [cacheHeight] The desired height of the image cache.
    final int? cacheHeight,

    /// [scale] The scale to apply to the image.
    final double scale = 1.0,

    /// [borderRadius] The border radius of the image widget.
    final BorderRadiusGeometry borderRadius = BorderRadius.zero,

    /// [key] The key for the image widget.
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
      key: key,
    );
  }

  static Widget imageHashPreviewCircular({
    /// [imagePath] The URL or path of the image to be displayed.
    required final String imagePath,

    /// [size] The size of the circular image.
    final double size = 50.0,

    /// [placeholderColor] The color to be displayed as a placeholder while the image is loading.
    final Color? placeholderColor,

    /// [curve] The animation curve used for transitioning the image.
    final Curve curve = Curves.easeOut,

    /// [fit] The fit of the image within the circular widget.
    final BoxFit fit = BoxFit.cover,

    /// [decodingHeight] The height used to decode the image.
    final int decodingHeight = 32,

    /// [decodingWidth] The width used to decode the image.
    final int decodingWidth = 32,

    /// [duration] The duration of the transition animation.
    final Duration duration = const Duration(milliseconds: 1000),

    /// [onDecoded] A callback function invoked when the image is decoded.
    final void Function()? onDecoded,

    /// [onStarted] A callback function invoked when the image loading process starts.
    final void Function()? onStarted,

    /// [onReady] A callback function invoked when the image is ready for display.
    final void Function()? onReady,

    /// [onDisplayed] A callback function invoked when the image is displayed.
    final void Function()? onDisplayed,

    /// [colorBlendMode] The blend mode used to blend the image with the background color.
    final BlendMode? colorBlendMode,

    /// [color] The color applied as a filter to the image.
    final Color? color,

    /// [alignment] The alignment of the image within its bounding box.
    final Alignment alignment = Alignment.center,

    /// [centerSlice] The rectangle inside the image used for centering and scaling.
    final Rect? centerSlice,

    /// [opacity] The opacity of the image.
    final Animation<double>? opacity,

    /// [filterQuality] The quality of the image filtering.
    final FilterQuality filterQuality = FilterQuality.low,

    /// [repeat] The strategy to use when painting the image.
    final ImageRepeat repeat = ImageRepeat.noRepeat,

    /// [matchTextDirection] Whether to match the direction of the image with the direction of the text.
    final bool matchTextDirection = false,

    /// [gapLessPlayback] Whether to gaplessly loop a finite set of images.
    final bool gapLessPlayback = false,

    /// [semanticLabel] A semantic description of the image.
    final String? semanticLabel,

    /// [frameBuilder] A builder function used to create custom frames for the image.
    final ImageFrameBuilder? frameBuilder,

    /// [loadingBuilder] A builder function used to create custom widgets while the image is loading.
    final ImageLoadingBuilder? loadingBuilder,

    /// [errorBuilder] A builder function used to create custom error widgets.
    final ImageErrorWidgetBuilder? errorBuilder,

    /// [isAntiAlias] Whether to use anti-aliasing when painting the image.
    final bool isAntiAlias = false,

    /// [headers] Optional HTTP headers to include in the image request.
    final Map<String, String>? headers,

    /// [cacheWidth] The desired width of the image cache.
    final int? cacheWidth,

    /// [cacheHeight] The desired height of the image cache.
    final int? cacheHeight,

    /// [scale] The scale to apply to the image.
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

  static Widget blurIsWeb({
    /// The placeholder image displayed while the main image is loading.
    ///
    /// This image is shown with a blur effect until the main image is fully loaded.
    required final ImageProvider<Object> placeholder,

    /// The thumbnail image displayed as a preview before the main image is loaded.
    required final ImageProvider<Object> thumbnail,

    /// The main image to be displayed.
    required final ImageProvider<Object> image,

    /// The width of the image widget.
    final double? width,

    /// The height of the image widget.
    final double? height,

    /// How to inscribe the image into the space allocated during layout.
    final BoxFit? fit,

    /// The duration of the fade animation when the main image is loaded.
    final Duration? fadeDuration,

    /// How to align the image within its bounds.
    final Alignment? alignment,

    /// How to paint any portions of the box that are not covered by the image.
    final ImageRepeat? repeat,

    /// Whether to match the direction of text for the image.
    final bool? matchTextDirection,

    /// The amount of blur to apply to the placeholder image.
    final double? blur,

    /// Whether to exclude this image from semantics.
    final bool? excludeFromSemantics,

    /// A semantic description of the image.
    final String? imageSemanticLabel,

    /// The background color to display while the image is loading.
    final Color? backgroundColor,

    /// The border radius of the image.
    final BorderRadius? borderRadius,

    /// The box shadow of the image.
    final List<BoxShadow>? boxShadow,

    /// A callback that is called when the image is tapped.
    final void Function()? onTap,

    /// Whether to enable hover effects on the image.
    final bool enableHover = false,

    /// A widget to display when the image fails to load.
    final Widget Function(BuildContext, Object)? errorWidget,

    /// A builder function that is called when the image is loading.
    final Widget Function(BuildContext, Widget, ImageChunkEvent?)?
    loadingBuilder,

    /// The key for the image widget.
    final Key? key,

    /// Creates a [BlurIsWeb] widget.
    ///
    /// The [placeholder], [thumbnail], and [image] parameters are required.
  }) {
    return BlurIsWeb(
      placeholder: placeholder,
      thumbnail: thumbnail,
      image: image,
      width: width,
      height: height,
      fit: fit,
      fadeDuration: fadeDuration,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      excludeFromSemantics: excludeFromSemantics,
      imageSemanticLabel: imageSemanticLabel,
      blur: blur,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      onTap: onTap,
      enableHover: enableHover,
      errorWidget: errorWidget,
      loadingBuilder: loadingBuilder,
      key: key,
    );
  }

  static Widget imageBlurGetPalletteColor({
    /// [imageUrl] The path or URL of the image to be displayed.
    required final String imageUrl,

    ///Default [BoxFit.cover]
    final BoxFit? fit = BoxFit.cover,

    /// [height] non-null, requires the child to have exactly this height.
    final double? height,

    /// [width] non-null, requires the child to have exactly this width.
    final double? width,

    ///Used to combine [color] with this image.
    ///The default is [BlendMode.srcIn]. In terms of the blend mode, [color] is the source and this image is the destination.
    ///See also:
    ///[BlendMode], which includes an illustration of the effect of each blend mode.
    final BlendMode? colorBlendMode = BlendMode.srcIn,

    ///If non-null, this color is blended with each image pixel using [colorBlendMode].
    final Color? color,

    /// How to align the image within its bounds.

    ///The alignment aligns the given position in the image to the given position in the layout bounds. For example, an [Alignment] alignment of (-1.0, -1.0) aligns the image to the top-left corner of its layout bounds, while an [Alignment] alignment of (1.0, 1.0) aligns the bottom right of the image with the bottom right corner of its layout bounds. Similarly, an alignment of (0.0, 1.0) aligns the bottom middle of the image with the middle of the bottom edge of its layout bounds.

    ///To display a subpart of an image, consider using a [CustomPainter] and [Canvas.drawImageRect].

    ///If the [alignment] is [TextDirection]-dependent (i.e. if it is a [AlignmentDirectional]), then an ambient [Directionality] widget must be in scope.

    ///Defaults to [Alignment.center].

    //See also:

    ///[Alignment], a class with convenient constants typically used to specify an [AlignmentGeometry].
    ///[AlignmentDirectional], like [Alignment] for specifying alignments relative to text direction.
    final Alignment alignment = Alignment.center,

    ///The center slice for a nine-patch image.
    final Rect? centerSlice,

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
    final Animation<double>? opacity,

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
    final FilterQuality filterQuality = FilterQuality.low,

    ///How to paint any portions of the layout bounds not covered by the image.
    final ImageRepeat repeat = ImageRepeat.noRepeat,

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
    final bool matchTextDirection = false,

    /// Whether the image should be played in the background when it's not visible.
    final bool gapLessPlayback = false,

    /// The semantic label for this image.
    final String? semanticLabel,

    /// A builder function that is called if an error occurs during image loading.
    final ImageFrameBuilder? frameBuilder,

    /// A builder function that is called if an error occurs during image loading.
    final ImageLoadingBuilder? loadingBuilder,

    /// A builder function that is called if an error occurs during image loading.
    final ImageErrorWidgetBuilder? errorBuilder,

    /// Whether to paint the image with anti-aliasing.
    final bool isAntiAlias = false,

    /// The headers used for http requests.
    final Map<String, String>? headers,

    /// The width and height of the image in logical pixels.
    final int? cacheWidth,

    /// The width and height of the image in logical pixels.
    final int? cacheHeight,

    /// The color to use when drawing the image.
    final TileMode tileMode = TileMode.decal,

    /// The duration of the fade-in effect.
    final Duration fadeInDuration = const Duration(milliseconds: 500),

    ///The color of the placeholder image.
    final Color backgroundImage = const Color.fromRGBO(238, 238, 238, 1),

    /// The height and width of the image in logical pixels.
    final double scale = 1.0,

    /// The height and width of the image in logical pixels.
    final int? memCacheHeight,

    /// The height and width of the image in logical pixels.
    final int? memCacheWidth,

    ///The color of the placeholder image.
    final Color? placeholderColor = const Color.fromRGBO(224, 224, 224, 1),

    ///If non-null, the corners of this box are rounded by this [BorderRadius].
    ///Applies only to boxes with rectangular shapes; ignored if [shape] is not [BoxShape.rectangle].
    ///The [shape] or the [borderRadius] won't clip the children of the decorated [Container].
    /// If the clip is required, insert a clip widget (e.g., [ClipRect], [ClipRRect], [ClipPath]) as the child of the [Container].
    ///  Be aware that clipping may be costly in terms of performance.
    final BorderRadiusGeometry borderRadius = BorderRadius.zero,

    /// Fetches the image and generates the palette color
    final Future<PaletteGeneratorMaster?>? Function(
      Future<PaletteGeneratorMaster>?,
    )?
    onPaletteReceived,

    /// [key] for [ImageBlurGetPalletteColor]
    Key? key,
  }) {
    return ImageBlurGetPalletteColor(
      imageUrl: imageUrl,
      height: height,
      width: width,
      borderRadius: borderRadius,
      fit: fit,
      onPaletteReceived: onPaletteReceived,
      placeholderColor: placeholderColor,
      memCacheHeight: memCacheHeight,
      memCacheWidth: memCacheWidth,
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
      tileMode: tileMode,
      fadeInDuration: fadeInDuration,
      backgroundImage: backgroundImage,
      scale: scale,
      alignment: alignment,
      centerSlice: centerSlice,
      color: color,
      colorBlendMode: colorBlendMode,
      opacity: opacity,
      key: key,
    );
  }

  static Widget imageHashGetPaletteColor({
    /// [imagePath] The path or URL of the image to be displayed.
    required final String imagePath,

    /// [width] The width of the image widget.
    final double? width,

    /// [height] The height of the image widget.
    final double? height,

    /// [placeholderColor] The color to display as a placeholder while the image is loading.
    final Color? placeholderColor = const Color.fromRGBO(224, 224, 224, 1),

    /// [curve] The curve used for animation transitions.
    final Curve curve = Curves.easeOut,

    /// [fit] How the image should be inscribed into the space allocated during layout.
    final BoxFit fit = BoxFit.cover,

    /// [decodingHeight] The height used to decode the image.
    final int decodingHeight = 32,

    /// [decodingWidth] The width used to decode the image.
    final int decodingWidth = 32,

    /// [duration] The duration of the transition animation.
    final Duration duration = const Duration(milliseconds: 1000),

    /// [onDecoded] A callback function invoked when the image is decoded.
    final void Function()? onDecoded,

    /// [onStarted] A callback function invoked when the image loading process starts.
    final void Function()? onStarted,

    /// [onReady] A callback function invoked when the image is ready for display.
    final void Function()? onReady,

    /// [onDisplayed] A callback function invoked when the image is displayed.
    final void Function()? onDisplayed,

    /// [colorBlendMode] The blend mode used to blend the image with the background color.
    final BlendMode? colorBlendMode,

    /// [color] The color applied as a filter to the image.
    final Color? color,

    /// [alignment] The alignment of the image within its bounding box.
    final Alignment alignment = Alignment.center,

    /// [centerSlice] The rectangle inside the image used for centering and scaling.
    final Rect? centerSlice,

    /// [opacity] The opacity of the image.
    final Animation<double>? opacity,

    /// [filterQuality] The quality of the image filtering.
    final FilterQuality filterQuality = FilterQuality.low,

    /// [repeat] The strategy to use when painting the image.
    final ImageRepeat repeat = ImageRepeat.noRepeat,

    /// [matchTextDirection] Whether to match the direction of the image with the direction of the text.
    final bool matchTextDirection = false,

    /// [gapLessPlayback] Whether to gaplessly loop a finite set of images.
    final bool gapLessPlayback = false,

    /// [semanticLabel] A semantic description of the image.
    final String? semanticLabel,

    /// [frameBuilder] A builder function used to create custom frames for the image.
    final ImageFrameBuilder? frameBuilder,

    /// [loadingBuilder] A builder function used to create custom widgets while the image is loading.
    final ImageLoadingBuilder? loadingBuilder,

    /// [errorBuilder] A builder function used to create custom error widgets.
    final ImageErrorWidgetBuilder? errorBuilder,

    /// [isAntiAlias] Whether to use anti-aliasing when painting the image.
    final bool isAntiAlias = false,

    /// [headers] Optional HTTP headers to include in the image request.
    final Map<String, String>? headers,

    /// [cacheWidth] The desired width of the image cache.
    final int? cacheWidth,

    /// [cacheHeight] The desired height of the image cache.
    final int? cacheHeight,

    /// [scale] The scale to apply to the image.
    final double scale = 1.0,

    /// [borderRadius] The border radius of the image widget.
    final BorderRadiusGeometry borderRadius = BorderRadius.zero,

    /// Fetches the image and generates the palette color
    final Future<PaletteGeneratorMaster?>? Function(
      Future<PaletteGeneratorMaster>?,
    )?
    onPaletteReceived,
    Key? key,
  }) {
    return ImageHashGetPaletteColor(
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

  static Widget optimizedImageHashPreview({
    /// The path to the image. Can be a local path or a network URL.
    required final String imagePath,

    /// The width of the image.
    final double? width,

    /// The height of the image.
    final double? height,

    /// How to inscribe the image into the space allocated during layout.
    /// The default value is [BoxFit.cover].
    final BoxFit fit = BoxFit.cover,

    /// The color to use as a placeholder before the BlurHash is loaded.
    final Color? placeholderColor,

    /// The border radius of the image.
    final BorderRadiusGeometry borderRadius = BorderRadius.zero,

    /// The duration of the fade-in animation when the actual image is loaded.
    final Duration duration = const Duration(milliseconds: 500),

    /// A callback function that is called when the image is fully loaded.
    final Function()? onLoaded,

    /// A callback function that is called when an error occurs.
    final Widget Function(BuildContext, Object)? errorBuilder,

    /// Delay before starting to load the actual image after hash is loaded.
    final Duration hashLoadDelay = const Duration(milliseconds: 100),

    /// Delay before showing the actual image after it's loaded.
    final Duration imageShowDelay = const Duration(milliseconds: 300),

    /// The width to decode the BlurHash. Higher values = more detail but slower.
    final int decodingWidth = 32,

    /// The height to decode the BlurHash. Higher values = more detail but slower.
    final int decodingHeight = 32,

    /// The quality of the image filtering.
    final FilterQuality filterQuality = FilterQuality.high,
  }) {
    return OptimizedImageHashPreview(
      imagePath: imagePath,
      borderRadius: borderRadius,
      duration: duration,
      fit: fit,
      height: height,
      width: width,
      onLoaded: onLoaded,
      placeholderColor: placeholderColor,
      errorBuilder: errorBuilder,
      hashLoadDelay: hashLoadDelay,
      imageShowDelay: imageShowDelay,
      decodingWidth: decodingWidth,
      decodingHeight: decodingHeight,
      filterQuality: filterQuality,
    );
  }

  @override
  State<ImageBlur> createState() => _ImageBlurState();
  static ImageBlur instance() => ImageBlur(imageUrl: '');
  static Future<void> init({int removeCacheTime = 30}) async {
    await FastCachedImageConfig.init(
      clearCacheAfter: Duration(minutes: removeCacheTime),
    );
  }
}

class _ImageBlurState extends State<ImageBlur> {
  double _blurValue = 25.0;

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
