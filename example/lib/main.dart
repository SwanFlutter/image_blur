import 'package:flutter/material.dart';
import 'package:image_blur/image_blur.dart';

void main() async {
  await ImageBlur.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url =
      "https://img.freepik.com/free-photo/pier-lake-hallstatt-austria_181624-44201.jpg?size=626&ext=jpg&uid=R22994307&ga=GA1.1.1899687920.1695643728&semt=ais";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Flutter Demo Home Page"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: 1500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.4,
                child: ImageBlur.blurIsWeb(
                  placeholder: "assets/placeholder.jpg",
                  fit: BoxFit.cover,
                  thumbnail: url,
                  image: url,
                  width: size.width * 0.3,
                  height: size.height * 0.4,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.4,
                child: ImageBlur(
                  imageUrl: url,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.4,
                child: ImageBlur.imageHashPreview(
                  imagePath: url,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.4,
                child: ImageBlur.imageCircularBlur(
                  imageNetwork: url,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.4,
                child: ImageBlur.imageHashPreviewCircular(
                  imagePath: url,
                ),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
