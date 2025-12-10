// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:image_blur/image_blur.dart';
import 'package:image_blur_web/image_blur_web.dart';

/// A widget that displays an image with a blurred placeholder and a thumbnail.
///
/// The [BlurIsWeb] widget requires three mandatory parameters: [placeholder], [thumbnail],
/// and [image]. The rest of the parameters are optional and can be used to customize the widget.
/// Example
/// ```dart
/// ImageBlur.blurIsWeb(
///   placeholder: 'assets/example.png',
///   thumbnail: 'https://backend.example.com/thumbnail.png',
///   image: 'https://backend.example.com/image.png',
///   height: 300,
///   width: 500,
/// );
///```
///

class BlurIsWeb extends StatelessWidget {
  /// The placeholder image displayed while the main image is loading.
  ///
  /// This image is shown with a blur effect until the main image is fully loaded.
  final ImageProvider<Object> placeholder;

  /// The thumbnail image displayed as a preview before the main image is loaded.
  final ImageProvider<Object> thumbnail;

  /// The main image to be displayed.
  final ImageProvider<Object> image;

  /// The width of the image widget.
  final double? width;

  /// The height of the image widget.
  final double? height;

  /// How to inscribe the image into the space allocated during layout.
  final BoxFit? fit;

  /// The duration of the fade animation when the main image is loaded.
  final Duration? fadeDuration;

  /// How to align the image within its bounds.
  final Alignment? alignment;

  /// How to paint any portions of the box that are not covered by the image.
  final ImageRepeat? repeat;

  /// Whether to match the direction of text for the image.
  final bool? matchTextDirection;

  /// The amount of blur to apply to the placeholder image.
  final double? blur;

  /// Whether to exclude this image from semantics.
  final bool? excludeFromSemantics;

  /// A semantic description of the image.
  final String? imageSemanticLabel;

  /// The background color to display while the image is loading.
  final Color? backgroundColor;

  /// The border radius of the image.
  final BorderRadius? borderRadius;

  /// The box shadow of the image.
  final List<BoxShadow>? boxShadow;

  /// A callback that is called when the image is tapped.
  final void Function()? onTap;

  /// Whether to enable hover effects on the image.
  final bool enableHover;

  /// A widget to display when the image fails to load.
  final Widget Function(BuildContext, Object)? errorWidget;

  /// A builder function that is called when the image is loading.
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;

  /// Creates a [BlurIsWeb] widget.
  ///
  /// The [placeholder], [thumbnail], and [image] parameters are required.

  BlurIsWeb({
    super.key,
    required this.placeholder,
    required this.thumbnail,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fadeDuration = const Duration(milliseconds: 800),
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.blur = 20.0,
    this.excludeFromSemantics = false,
    this.imageSemanticLabel,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
    this.errorWidget,
    this.enableHover = true,
    this.loadingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ImageBlurWeb(
      placeholder: placeholder,
      thumbnail: thumbnail,
      image: image,
      width: width ?? 200,
      height: height ?? 200,
      fit: fit ?? BoxFit.cover,
      fadeDuration: fadeDuration ?? const Duration(milliseconds: 800),
      alignment: alignment ?? Alignment.center,
      repeat: repeat ?? ImageRepeat.noRepeat,
      matchTextDirection: matchTextDirection ?? false,
      excludeFromSemantics: excludeFromSemantics ?? false,
      imageSemanticLabel: imageSemanticLabel,
      blur: blur ?? 0.0,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      onTap: onTap,
      enableHover: enableHover,
      errorWidget: errorWidget,
      loadingBuilder: loadingBuilder,
    );
  }
}
