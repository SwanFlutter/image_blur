import 'dart:ui';

import 'package:flutter/material.dart';

import '../tools/shimmer_image_tools.dart';

/// A circular image widget with options for applying BlurHash and shimmer effects.
class ImageCircularBlur extends StatelessWidget {
  ///[imageNetwork] The URL of the image to be loaded from the network.
  final String? imageNetwork;

  /// [imageAssets] The path of the image to be loaded from the assets.
  final String? imageAssets;

  /// [durationShimmer] The duration of the shimmer effect animation in seconds.
  final int durationShimmer;

  /// [durationBlur] The duration of the blur effect animation in seconds.
  final int durationBlur;

  /// [size] The size of the circular image.
  final double? size;

  /// [fit] The fit of the image within the circular widget.
  final BoxFit? fit;

  /// [colorBlendMode] The blend mode used to blend the image with the background color.
  final BlendMode? colorBlendMode;

  /// [color] The color applied as a filter to the image.
  final Color? color;

  /// [alignment] The alignment of the image within its bounding box.
  final AlignmentGeometry alignment;

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

  /// [isBlur] Whether to apply BlurHash effect to the image.
  final bool isBlur;

  /// [isShimmer] Whether to display shimmer effect while loading the image.
  final bool isShimmer;

  /// [headers] Optional HTTP headers to include in the image request.
  final Map<String, String>? headers;

  /// [cacheWidth] The desired width of the image cache.
  final int? cacheWidth;

  /// [cacheHeight] The desired height of the image cache.
  final int? cacheHeight;

  /// [baseColorShimmer] The base color of the shimmer effect.
  final Color baseColorShimmer;

  /// [highlightColorShimmer] The highlight color of the shimmer effect.
  final Color highlightColorShimmer;

  /// [colorShimmer] The color of the shimmer effect.
  final Color colorShimmer;

  /// [placeholderColor] The color to be displayed as a placeholder while the image is loading.
  final Color? placeholderColor;

  const ImageCircularBlur({
    super.key,
    this.imageNetwork,
    this.imageAssets,
    this.durationShimmer = 2,
    this.durationBlur = 2,
    this.size,
    this.fit = BoxFit.cover,
    this.colorBlendMode = BlendMode.srcIn,
    this.color,
    this.alignment = Alignment.center,
    this.centerSlice,
    this.opacity,
    this.errorBuilder,
    this.filterQuality = FilterQuality.low,
    this.frameBuilder,
    this.gapLessPlayback = false,
    this.loadingBuilder,
    this.matchTextDirection = false,
    this.repeat = ImageRepeat.noRepeat,
    this.semanticLabel,
    this.isAntiAlias = false,
    this.isBlur = true,
    this.isShimmer = true,
    this.cacheHeight,
    this.cacheWidth,
    this.headers,
    this.baseColorShimmer = const Color.fromRGBO(224, 224, 224, 1),
    this.highlightColorShimmer = const Color.fromRGBO(245, 245, 245, 1),
    this.colorShimmer = Colors.white,
    this.placeholderColor = const Color.fromRGBO(224, 224, 224, 1),
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: placeholderColor,
      ),
      child: ClipOval(
        child: FutureBuilder(
          future: Future.delayed(
            Duration(seconds: isShimmer ? durationShimmer : 0),
            () => true,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return isShimmer
                  ? ShimmerImage(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      baseColorShimmer: baseColorShimmer,
                      colorShimmer: colorShimmer,
                      highlightColorShimmer: highlightColorShimmer,
                    )
                  : const SizedBox.shrink();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return FutureBuilder(
                future: Future.delayed(
                  Duration(seconds: isBlur ? durationBlur : 0),
                  () => true,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return isBlur
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              (imageAssets != null || imageNetwork != null)
                                  ? (imageAssets != null
                                        ? Image.asset(
                                            imageAssets!,
                                            fit: BoxFit.cover,
                                            height: MediaQuery.of(
                                              context,
                                            ).size.height,
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                          )
                                        : Image.network(
                                            imageNetwork!,
                                            fit: BoxFit.cover,
                                            height: MediaQuery.of(
                                              context,
                                            ).size.height,
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                          ))
                                  : const Text("Image not provided"),
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 5.0,
                                  sigmaY: 5.0,
                                  tileMode: TileMode.decal,
                                ),
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.1),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (imageNetwork != null || imageAssets != null) {
                      return (imageNetwork != null
                          ? Container(
                              color: Colors.grey.shade300,
                              child: Image.network(
                                imageNetwork!,
                                fit: BoxFit.cover,
                                colorBlendMode: colorBlendMode,
                                color: color,
                                alignment: alignment,
                                height: size,
                                width: size,
                                centerSlice: centerSlice,
                                errorBuilder: errorBuilder,
                                filterQuality: filterQuality,
                                frameBuilder: frameBuilder,
                                gaplessPlayback: gapLessPlayback,
                                isAntiAlias: isAntiAlias,
                                loadingBuilder: loadingBuilder,
                                opacity: opacity,
                                semanticLabel: semanticLabel,
                                repeat: repeat,
                                matchTextDirection: matchTextDirection,
                                cacheHeight: cacheHeight,
                                cacheWidth: cacheWidth,
                                headers: headers,
                              ),
                            )
                          : Container(
                              color: Colors.grey.shade300,
                              child: Image.asset(
                                imageAssets!,
                                fit: BoxFit.cover,
                                colorBlendMode: colorBlendMode,
                                color: color,
                                alignment: alignment,
                                height: size,
                                width: size,
                                centerSlice: centerSlice,
                                errorBuilder: errorBuilder,
                                filterQuality: filterQuality,
                                frameBuilder: frameBuilder,
                                gaplessPlayback: gapLessPlayback,
                                isAntiAlias: isAntiAlias,
                                opacity: opacity,
                                semanticLabel: semanticLabel,
                                repeat: repeat,
                                matchTextDirection: matchTextDirection,
                                cacheHeight: cacheHeight,
                                cacheWidth: cacheWidth,
                              ),
                            ));
                    } else {
                      return const Text("Image not provided");
                    }
                  } else {
                    return Text("${snapshot.error}");
                  }
                },
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              return Container();
            } else {
              return Text("${snapshot.error}");
            }
          },
        ),
      ),
    );
  }
}
