import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  print('Generating app icon...');

  final int size = 1024;
  final image = img.Image(width: size, height: size);

  // Background (Contacts Blue: #1A73E8)
  img.fill(image, color: img.ColorRgba8(26, 115, 232, 255));

  // Head
  img.fillCircle(
    image,
    x: size ~/ 2,
    y: (size * 0.35).toInt(),
    radius: (size * 0.18).toInt(),
    color: img.ColorRgba8(255, 255, 255, 255),
  );

  // Body (Ellipse cut off at bottom to simulate shoulders)
  img.fillCircle(
    image,
    x: size ~/ 2,
    y: (size * 0.75).toInt(),
    radius: (size * 0.35).toInt(),
    color: img.ColorRgba8(255, 255, 255, 255),
  );

  // Save to file
  final pngBytes = img.encodePng(image);
  final file = File('assets/icons/app_icon.png');
  file.writeAsBytesSync(pngBytes);
  print('Saved valid PNG to ${file.path}');
}
