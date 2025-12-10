import 'package:flutter_test/flutter_test.dart';
import 'package:image_blur/image_blur.dart';

void main() {
  test('adds one to input values', () {
    final calculator = ImageBlur(imageUrl: '');
    expect(calculator.cacheHeight, 3);
  });
}
