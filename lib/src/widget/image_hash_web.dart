// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:image_blur/image_blur.dart';

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
  final String placeholder;

  /// The thumbnail image displayed as a preview before the main image is loaded.
  final String thumbnail;

  /// The main image to be displayed.
  final String image;

  /// The width of the image widget.
  final double? width;

  /// The height of the image widget.
  final double? height;

  /// The asset bundle to use for loading the placeholder.
  final AssetBundle? bundle;

  /// The scale for the thumbnail image.
  final double? thumbnailScale;

  /// The scale for the main image.
  final double? imageScale;

  /// The scale for the placeholder image.
  final double? placeholderScale;

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

  /// Creates a [BlurIsWeb] widget.
  ///
  /// The [placeholder], [thumbnail], and [image] parameters are required.

  BlurIsWeb({
    Key? key,
    required this.placeholder,
    required this.thumbnail,
    required this.image,
    this.width,
    this.height,
    this.bundle,
    this.thumbnailScale = 1.0,
    this.imageScale = 1.0,
    this.placeholderScale = 1.0,
    this.fit = BoxFit.cover,
    this.fadeDuration = const Duration(milliseconds: 500),
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.blur = 0.0,
    this.excludeFromSemantics = false,
    this.imageSemanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressiveImage.assetNetwork(
      placeholder: placeholder,
      thumbnail: thumbnail,
      image: image,
      width: width ?? 200,
      height: height ?? 200,
      bundle: bundle,
      thumbnailScale: thumbnailScale ?? 1.0,
      imageScale: imageScale ?? 1.0,
      placeholderScale: placeholderScale ?? 1.0,
      fit: fit ?? BoxFit.cover,
      fadeDuration: fadeDuration ?? const Duration(milliseconds: 500),
      alignment: alignment ?? Alignment.center,
      repeat: repeat ?? ImageRepeat.noRepeat,
      matchTextDirection: matchTextDirection ?? false,
      excludeFromSemantics: excludeFromSemantics ?? false,
      imageSemanticLabel: imageSemanticLabel,
      blur: blur ?? 0.0,
    );
  }
}
