import 'package:example/hash_image_test.dart';
import 'package:example/palet_color.dart';
import 'package:flutter/material.dart';
import 'package:image_blur/image_blur.dart';

void main() async {
  await ImageBlur.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Blur Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Image Blur Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExampleButton(
            context,
            title: 'Hash Preview Grid',
            subtitle: 'ImageBlur.imageHashPreview in GridView',
            page: const HashImageTest(),
          ),
          _buildExampleButton(
            context,
            title: 'Optimized Hash Preview',
            subtitle: 'ImageBlur.optimizedImageHashPreview with caching',
            page: const HashImageTest1(),
          ),
          _buildExampleButton(
            context,
            title: 'Palette Color Extraction',
            subtitle: 'Extract dominant colors from images',
            page: const ColorPaletteHome(),
          ),
          _buildExampleButton(
            context,
            title: 'All Widgets Demo',
            subtitle: 'See all ImageBlur widgets in action',
            page: const AllWidgetsDemo(),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      ),
    );
  }
}

/// Demo page showing all ImageBlur widgets
class AllWidgetsDemo extends StatelessWidget {
  const AllWidgetsDemo({super.key});

  static const String sampleImage = 'https://picsum.photos/id/10/400/300';
  static const String sampleImage2 = 'https://picsum.photos/id/15/400/300';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Widgets Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. ImageBlur - Progressive blur loading
          _buildSection(
            title: '1. ImageBlur',
            description: 'Progressive blur effect during loading',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: ImageBlur(imageUrl: sampleImage, fit: BoxFit.cover),
              ),
            ),
          ),

          // 2. ImageHashPreview - BlurHash placeholder
          _buildSection(
            title: '2. ImageHashPreview',
            description: 'BlurHash placeholder while loading',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: ImageBlur.imageHashPreview(
                  imagePath: sampleImage2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 3. ImageCircularBlur - Circular with shimmer
          _buildSection(
            title: '3. ImageCircularBlur',
            description: 'Circular image with shimmer effect',
            child: Center(
              child: ImageBlur.imageCircularBlur(
                size: 150,
                imageNetwork: sampleImage,
                isShimmer: true,
                isBlur: true,
              ),
            ),
          ),

          // 4. ImageHashPreviewCircular
          _buildSection(
            title: '4. ImageHashPreviewCircular',
            description: 'Circular BlurHash preview',
            child: Center(
              child: ImageBlur.imageHashPreviewCircular(
                size: 150,
                imagePath: sampleImage2,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 5. OptimizedImageHashPreview
          _buildSection(
            title: '5. OptimizedImageHashPreview',
            description: 'Optimized with caching & configurable delays',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: ImageBlur.optimizedImageHashPreview(
                  imagePath: 'https://picsum.photos/id/20/400/300',
                  fit: BoxFit.cover,
                  duration: const Duration(milliseconds: 500),
                  onLoaded: () => debugPrint('Image loaded!'),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
