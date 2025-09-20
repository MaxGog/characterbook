import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';

enum ExpressiveShape {
  circle,
  roundedSquare,
  squircle,
  diamond,
  blob1,
  blob2,
  blob3,
  blob4,
  star,
  heart,
  hexagon,
  octagon,
  cloud,
  flower,
  droplet,
}

class ExpressiveAvatar extends StatelessWidget {
  final Uint8List? imageBytes;
  final double size;
  final ExpressiveShape? shape;
  final Color backgroundColor;
  final double rotation;
  final Offset offset;

  const ExpressiveAvatar({
    super.key,
    this.imageBytes,
    this.size = 64,
    this.shape,
    this.backgroundColor = Colors.transparent,
    this.rotation = 0,
    this.offset = Offset.zero,
  });

  factory ExpressiveAvatar.random({
    Uint8List? imageBytes,
    double minSize = 50,
    double maxSize = 90,
    bool randomRotation = true,
    bool randomOffset = true,
  }) {
    final random = Random();
    final actualSize = minSize + random.nextDouble() * (maxSize - minSize);
    final actualShape = ExpressiveShape.values[random.nextInt(ExpressiveShape.values.length)];
    final actualOffset = randomOffset 
        ? Offset(
            (random.nextDouble() - 0.5) * 20,
            (random.nextDouble() - 0.5) * 20,
          )
        : Offset.zero;

    return ExpressiveAvatar(
      imageBytes: imageBytes,
      size: actualSize,
      shape: actualShape,
      offset: actualOffset,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final actualShape = shape ?? ExpressiveShape.values[Random().nextInt(ExpressiveShape.values.length)];
    
    final Widget avatarContent = imageBytes != null
        ? ClipPath(
            clipper: _ExpressiveShapeClipper(actualShape),
            child: Transform.rotate(
              angle: rotation,
              child: Image.memory(
                imageBytes!,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),
          )
        : Transform.rotate(
            angle: rotation,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                shape: actualShape == ExpressiveShape.circle ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: actualShape == ExpressiveShape.roundedSquare 
                    ? BorderRadius.circular(size * 0.25)
                    : actualShape == ExpressiveShape.squircle
                        ? BorderRadius.circular(size * 0.35)
                        : null,
              ),
              child: Icon(
                Icons.person,
                size: size * 0.6,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          );

    return Transform.translate(
      offset: offset,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: actualShape == ExpressiveShape.circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: _getBorderRadius(actualShape),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _ExpressiveShapePainter(actualShape, backgroundColor),
          child: avatarContent,
        ),
      ),
    );
  }

  BorderRadius? _getBorderRadius(ExpressiveShape shape) {
    switch (shape) {
      case ExpressiveShape.roundedSquare:
        return BorderRadius.circular(size * 0.25);
      case ExpressiveShape.squircle:
        return BorderRadius.circular(size * 0.35);
      case ExpressiveShape.diamond:
      case ExpressiveShape.blob1:
      case ExpressiveShape.blob2:
      case ExpressiveShape.blob3:
      case ExpressiveShape.blob4:
      case ExpressiveShape.star:
      case ExpressiveShape.heart:
      case ExpressiveShape.hexagon:
      case ExpressiveShape.octagon:
      case ExpressiveShape.cloud:
      case ExpressiveShape.flower:
      case ExpressiveShape.droplet:
        return null;
      default:
        return null;
    }
  }
}

class _ExpressiveShapeClipper extends CustomClipper<Path> {
  final ExpressiveShape shape;
  final Random random;

  _ExpressiveShapeClipper(this.shape, [Random? random]) 
      : random = random ?? Random();

  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    switch (shape) {
      case ExpressiveShape.circle:
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        break;
      case ExpressiveShape.roundedSquare:
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: size.width, height: size.height),
          Radius.circular(size.width * 0.25),
        ));
        break;
      case ExpressiveShape.squircle:
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: size.width, height: size.height),
          Radius.circular(size.width * 0.35),
        ));
        break;
      case ExpressiveShape.diamond:
        path
          ..moveTo(center.dx, 0)
          ..lineTo(size.width, center.dy)
          ..lineTo(center.dx, size.height)
          ..lineTo(0, center.dy)
          ..close();
        break;
      case ExpressiveShape.blob1:
        _createBlobPath(path, size, 0.3 + random.nextDouble() * 0.4);
        break;
      case ExpressiveShape.blob2:
        _createBlobPath(path, size, 0.4 + random.nextDouble() * 0.5);
        break;
      case ExpressiveShape.blob3:
        _createBlobPath(path, size, 0.5 + random.nextDouble() * 0.3);
        break;
      case ExpressiveShape.blob4:
        _createBlobPath(path, size, 0.2 + random.nextDouble() * 0.6);
        break;
      case ExpressiveShape.star:
        _createStarPath(path, size, 5 + random.nextInt(3));
        break;
      case ExpressiveShape.heart:
        _createHeartPath(path, size);
        break;
      case ExpressiveShape.hexagon:
        _createPolygonPath(path, size, 6);
        break;
      case ExpressiveShape.octagon:
        _createPolygonPath(path, size, 8);
        break;
      case ExpressiveShape.cloud:
        _createCloudPath(path, size);
        break;
      case ExpressiveShape.flower:
        _createFlowerPath(path, size, 5 + random.nextInt(3));
        break;
      case ExpressiveShape.droplet:
        _createDropletPath(path, size);
        break;
    }

    return path;
  }

  void _createBlobPath(Path path, Size size, double irregularity) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const points = 8;

    for (var i = 0; i < points; i++) {
      final angle = 2 * pi * i / points;
      final randomRadius = radius * (0.7 + irregularity * random.nextDouble());
      final x = center.dx + randomRadius * cos(angle);
      final y = center.dy + randomRadius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
  }

  void _createStarPath(Path path, Size size, int points) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * (0.3 + random.nextDouble() * 0.2);

    for (var i = 0; i < points * 2; i++) {
      final radius = i % 2 == 0 ? outerRadius : innerRadius;
      final angle = pi / points * i;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
  }

  void _createHeartPath(Path path, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width;
    final height = size.height;

    path
      ..moveTo(center.dx, height * 0.25)
      ..cubicTo(
        width * 0.1, height * 0.1,
        width * 0.1, height * 0.4,
        center.dx, height * 0.7,
      )
      ..cubicTo(
        width * 0.9, height * 0.4,
        width * 0.9, height * 0.1,
        center.dx, height * 0.25,
      )
      ..close();
  }

  void _createPolygonPath(Path path, Size size, int sides) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (var i = 0; i <= sides; i++) {
      final angle = 2 * pi * i / sides;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
  }

  void _createCloudPath(Path path, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    path
      ..moveTo(center.dx - radius * 0.6, center.dy)
      ..cubicTo(
        center.dx - radius * 0.8, center.dy - radius * 0.2,
        center.dx - radius * 0.6, center.dy - radius * 0.4,
        center.dx - radius * 0.3, center.dy - radius * 0.3,
      )
      ..cubicTo(
        center.dx - radius * 0.2, center.dy - radius * 0.6,
        center.dx + radius * 0.1, center.dy - radius * 0.5,
        center.dx + radius * 0.3, center.dy - radius * 0.4,
      )
      ..cubicTo(
        center.dx + radius * 0.6, center.dy - radius * 0.5,
        center.dx + radius * 0.7, center.dy - radius * 0.2,
        center.dx + radius * 0.5, center.dy,
      )
      ..cubicTo(
        center.dx + radius * 0.7, center.dy + radius * 0.2,
        center.dx + radius * 0.5, center.dy + radius * 0.4,
        center.dx + radius * 0.3, center.dy + radius * 0.3,
      )
      ..cubicTo(
        center.dx + radius * 0.1, center.dy + radius * 0.6,
        center.dx - radius * 0.2, center.dy + radius * 0.5,
        center.dx - radius * 0.3, center.dy + radius * 0.3,
      )
      ..cubicTo(
        center.dx - radius * 0.5, center.dy + radius * 0.4,
        center.dx - radius * 0.7, center.dy + radius * 0.2,
        center.dx - radius * 0.6, center.dy,
      )
      ..close();
  }

  void _createFlowerPath(Path path, Size size, int petals) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.4;

    for (var i = 0; i < petals * 2; i++) {
      final radius = i % 2 == 0 ? outerRadius : innerRadius;
      final angle = 2 * pi * i / (petals * 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
  }

  void _createDropletPath(Path path, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width;
    final height = size.height;

    path
      ..moveTo(center.dx, height * 0.1)
      ..cubicTo(
        width * 0.2, height * 0.1,
        width * 0.1, height * 0.5,
        center.dx, height * 0.9,
      )
      ..cubicTo(
        width * 0.9, height * 0.5,
        width * 0.8, height * 0.1,
        center.dx, height * 0.1,
      )
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ExpressiveShapePainter extends CustomPainter {
  final ExpressiveShape shape;
  final Color color;

  _ExpressiveShapePainter(this.shape, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = _ExpressiveShapeClipper(shape).getClip(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}