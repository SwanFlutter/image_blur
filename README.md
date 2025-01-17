
This Flutter package provides the ability to add shimmer and blur effects to your images. You can apply these effects in circular and rectangular shapes, and use them with both local and online images.

![blur](https://github.com/SwanFlutter/image_blur/assets/151648897/8278e724-2cfd-41ab-9a0d-5d60cd65e1bb)

## Initialize the cache configuration
```dart
void main() async {
  await ImageBlur.init();
  runApp(const MyApp());
}
```

## Features


```dart
ImageBlur.imageHashPreview(
imagePath: imageUrls[index],
width: size.width,
height: size.height,
);
```

![blur-3](https://github.com/SwanFlutter/image_blur/assets/151648897/4e065444-1c6d-4442-bcee-01a68e635ae1)



```dart
ImageBlur(
imageUrl: listimage[index],
);
```

![blur-4](https://github.com/SwanFlutter/image_blur/assets/151648897/39cabc43-6ddd-4e4f-bbde-82f7a32f3bf6)



```dart
ImageBlur.imageHashPreviewCircular(
 size: 340,
imagePath:
"https://img.freepik.com/free-vector/abstract-speaker-background_1048-2038.jpg?w=740&t=st=1708002577~exp=1708003177~hmac=75e6d3504cc3a4c077d56bcb181983b2ff88d51d5457a7dd10c039c3fec813d2",
)
```



![blur-1](https://github.com/SwanFlutter/image_blur/assets/151648897/19aada15-2690-4679-8c2f-48b497314fce)




```dart
ImageBlur.imageCircularBlur(
size: 340,
imageNetwork:
"https://img.freepik.com/free-photo/nature-tranquil-beauty-reflected-calm-water-generative-ai_188544-12798.jpg?size=626&ext=jpg&ga=GA1.1.8332681.1703272078&semt=ais",
),
```
![blur-2](https://github.com/SwanFlutter/image_blur/assets/151648897/5ed111cf-fb4b-4f51-8f10-8f811f4ec654)


```dart
ImageBlur.blurIsWeb(
   placeholder: "assets/placeholder.jpg",
   fit: BoxFit.cover,
  thumbnail: url,
   image: url,
  width: size.width * 0.3,
  height: size.height * 0.4,
),
```

- new 

Use only one image

```dart
ImageBlur.imageBlurGetPalletteColor(
  imageUrl: listimage[index],
)
```

- new

Use only one image

```dart
class _ColorPaletteHomeState extends State<ColorPaletteHome> {
  Color _appBarColor = Colors.blue; // Default AppBar color
  Color _backgroundColor = Colors.white; // Default background color

  void _updateColors(Color dominantColor) {
    setState(() {
      _appBarColor = dominantColor;
      _backgroundColor = dominantColor.withValues(alpha: 0.1); // Slightly lighter for background
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
          imagePath: "https://img.freepik.com/free-photo/pier-lake-hallstatt-austria_181624-44201.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais", // Replace with your image URL
          width: 300,
          height: 300,
          onPaletteReceived: (paletteFuture) async {
            final palette = await paletteFuture;
            if (palette != null && palette.lightVibrantColor != null) {
              _updateColors(palette.lightVibrantColor!.color);
            }
            return null;
          },
        ),
      ),
      backgroundColor: _backgroundColor,
    );
  }
}
```

![20240505_073705](https://github.com/SwanFlutter/image_blur/assets/151648897/d5a1f5a4-0b64-4059-9213-56bee562716c)


- new 

- optimizedImageHashPreview fast hash image


```dart
ImageBlur.optimizedImageHashPreview(
  imagePath: 'https://example.com/image.jpg',
  width: 300,
  height: 200,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(8),
  duration: Duration(milliseconds: 800),
  onLoaded: () {
    print('Image loaded successfully');
  },
)
```

## Getting started

```yaml
dependencies:
  image_blur: ^1.0.90
```

## How to use

```dart
import 'package:image_blur/image_blur.dart';

```

## Complete example
```dart

import 'package:flutter/material.dart';
import 'package:image_blur/image_blur.dart';

void main() async{
  await ImageBlur.init(removeCacheTime: 10);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(55, 151, 239, 1),
          primary: const Color.fromRGBO(55, 151, 239, 1),
        ),
        useMaterial3: true,
      ),
      home: const Search(),
    );
  }
}

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.95,
                    child: SearchBar(
                      hintText: 'Search',
                      shape: MaterialStatePropertyAll(BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                      hintStyle: const MaterialStatePropertyAll(
                          TextStyle(color: Colors.grey)),
                      elevation: MaterialStateProperty.all(1.0),
                      leading: const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 5.0),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        crossAxisCount: 3,),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ImageBlur(
                               imageUrls: imageUrls[index],
                              width: size.width,
                              height: size.height,
                            ),
                          ),
                        );
                      },
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```



## Additional information

If you have any issues, questions, or suggestions related to this package, please feel free to contact us at [swan.dev1993@gmail.com](mailto:zagros.development.group@gmail.com). We welcome your feedback and will do our best to address any problems or provide assistance.

For more information about this package, you can also visit our [GitHub repository](https://github.com/SwanFlutter/image_blur) where you can find additional resources, contribute to the package's development, and file issues or bug reports. We appreciate your contributions and feedback, and we aim to make this package as useful as possible for our users.

Thank you for using our package, and we look forward to hearing from you!
