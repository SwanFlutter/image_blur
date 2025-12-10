// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:image_blur/image_blur.dart';

class ColorPaletteHome extends StatefulWidget {
  const ColorPaletteHome({super.key});

  @override
  _ColorPaletteHomeState createState() => _ColorPaletteHomeState();
}

class _ColorPaletteHomeState extends State<ColorPaletteHome> {
  Color _appBarColor = Colors.blue; // Default AppBar color
  Color _backgroundColor = Colors.white; // Default background color

  void updateColors(Color dominantColor) {
    setState(() {
      _appBarColor = dominantColor;
      _backgroundColor = dominantColor.withValues(
        alpha: 0.1,
      ); // Slightly lighter for background
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Color Palette'),
        backgroundColor: _appBarColor,
      ),
      body: Center(
        child: ImageBlur.imageHashGetPaletteColor(
          imagePath:
              "https://img.freepik.com/free-photo/pier-lake-hallstatt-austria_181624-44201.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais", // Replace with your image URL
          width: 300,
          height: 300,
          onPaletteReceived: (paletteFuture) async {
            final palette = await paletteFuture;
            if (palette != null && palette.lightVibrantColor != null) {
              updateColors(palette.lightVibrantColor!.color);
            }
            return null;
          },
        ),
      ),
      backgroundColor: _backgroundColor,
    );
  }
}
