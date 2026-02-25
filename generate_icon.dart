import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

void main() async {
  print('Generating app icon...');

  // Create a 1024x1024 canvas
  const size = 1024.0;
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder, const ui.Rect.fromLTWH(0, 0, size, size));

  // Draw background (Google Contacts blue #1A73E8)
  final bgPaint = ui.Paint()..color = const ui.Color(0xFF1A73E8);
  canvas.drawRect(const ui.Rect.fromLTWH(0, 0, size, size), bgPaint);

  // Draw person icon
  final personPaint = ui.Paint()
    ..color = const ui.Color(0xFFFFFFFF)
    ..style = ui.PaintingStyle.fill;

  // Head
  canvas.drawCircle(
    const ui.Offset(size / 2, size * 0.35),
    size * 0.18,
    personPaint,
  );

  // Body (shoulders)
  final path = ui.Path();
  final rect = ui.Rect.fromLTWH(
    size * 0.15,
    size * 0.6,
    size * 0.7,
    size * 0.5,
  );
  path.addArc(rect, 3.14, 3.14); // Half circle for shoulders
  canvas.drawPath(path, personPaint);

  // Save to image
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.toInt(), size.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();

  // Ensure directory exists
  final dir = Directory('assets/icons');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  // Write file
  final file = File('assets/icons/app_icon.png');
  file.writeAsBytesSync(buffer);

  print('Icon generated successfully at ${file.path}');
}
