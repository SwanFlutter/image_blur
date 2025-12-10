import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerImage extends StatelessWidget {
  /// [height] The height of the shimmer effect.
  final double height;

  /// [width] The width of the shimmer effect.
  final double width;

  /// [baseColorShimmer] The base color used for the shimmer effect.
  final Color baseColorShimmer;

  /// [highlightColorShimmer] The highlight color used for the shimmer effect.
  final Color highlightColorShimmer;

  /// [colorShimmer] The color used to create the shimmer effect.
  final Color colorShimmer;

  const ShimmerImage({
    super.key,
    required this.height,
    required this.width,
    required this.baseColorShimmer,
    required this.highlightColorShimmer,
    required this.colorShimmer,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColorShimmer,
      highlightColor: highlightColorShimmer,
      child: SizedBox(
        height: height,
        width: width,
        child: Container(color: colorShimmer),
      ),
    );
  }
}
