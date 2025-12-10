import 'package:flutter/material.dart';
import 'package:image_blur/image_blur.dart';

class HashImageTest extends StatelessWidget {
  const HashImageTest({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('HashImageTest')),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: GridView.builder(
          itemCount: imageUrls3.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: true,
          cacheExtent: 1200,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return ImageBlur.imageHashPreview(
              imagePath: imageUrls3[index],
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(8.0),
            );
          },
        ),
      ),
    );
  }
}

class HashImageTest1 extends StatelessWidget {
  const HashImageTest1({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('HashImageTest')),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: GridView.builder(
          itemCount: imageUrls3.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: true,
          cacheExtent: 1200,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return ImageBlur.optimizedImageHashPreview(
              imagePath: imageUrls3[index],
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(8),
              duration: const Duration(milliseconds: 800),
              onLoaded: () {
                debugPrint('Image loaded successfully');
              },
            );
          },
        ),
      ),
    );
  }
}

const List<String> imageUrls = <String>[
  "https://img.freepik.com/free-photo/pier-lake-hallstatt-austria_181624-44201.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai_188544-9871.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/forest-landscape_71767-127.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/trees-drawn_1160-909.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/breathtaking-shot-beautiful-stones-turquoise-water-lake-hills-background_181624-12847.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/transparent-vivid-autumn-leaves_23-2148239689.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/view-old-tree-lake-with-snow-covered-mountains-cloudy-day_181624-28954.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/old-rusty-fishing-boat-slope-along-shore-lake_181624-44902.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/beautiful-nature-landscape-with-mountains-lake_23-2150705947.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/trees-drawn_1160-909.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/beautiful-mountain-lake-background-remix_53876-125213.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/closeup-yellow-leaves-branch-with-blue-blurred-background_181624-2238.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/vivid-colored-transparent-autumn-leaf_23-2148239739.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/morskie-oko-tatry_1204-510.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/boat-lake_1121-38.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/selective-focus-shot-brown-leaves-tree-branch-maksimir-park-zagreb-croatia_181624-24554.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/vivid-colored-transparent-fall-leaves_23-2148239737.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/vestrahorn-mountains-stokksnes-iceland_335224-667.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/purple-green-leaves-plant-perfect-backgroun_181624-57075.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/vivid-colored-transparent-autumn-leaves_23-2148239738.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/vertical-shot-beach-during-sunset_181624-31825.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/transparent-droplets-watery-orange-backdrop_23-2148290044.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
  "https://img.freepik.com/free-photo/grunge-style-watercolour-texture-background_1048-7931.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais",
];

List<String> imageUrls2 = <String>[
  for (int i = 1; i < 22; i++)
    "https://swanflutterdev.com/test_image/test_$i.jpg",
];

List<String> imageUrls3 = <String>[
  "https://picsum.photos/id/0/200/300",
  "https://picsum.photos/id/1/200/300",
  "https://picsum.photos/id/2/200/300",
  "https://picsum.photos/id/3/200/300",
  "https://picsum.photos/id/4/200/300",
  "https://picsum.photos/id/5/200/300",
  "https://picsum.photos/id/6/200/300",
  "https://picsum.photos/id/7/200/300",
  "https://picsum.photos/id/8/200/300",
  "https://picsum.photos/id/9/200/300",
  "https://picsum.photos/id/10/200/300",
  "https://picsum.photos/id/11/200/300",
  "https://picsum.photos/id/12/200/300",
  "https://picsum.photos/id/13/200/300",
  "https://picsum.photos/id/14/200/300",
  "https://picsum.photos/id/15/200/300",
  "https://picsum.photos/id/16/200/300",
  "https://picsum.photos/id/17/200/300",
  "https://picsum.photos/id/18/200/300",
  "https://picsum.photos/id/19/200/300",
  "https://picsum.photos/id/20/200/300",
  "https://picsum.photos/id/21/200/300",
  "https://picsum.photos/id/22/200/300",
];
