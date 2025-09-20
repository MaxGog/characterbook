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
  star,
  heart,
}

class ExpressiveAvatar extends StatelessWidget {
  final Uint8List? imageBytes;
  final double size;
  final ExpressiveShape shape;
  final Color backgroundColor;

  const ExpressiveAvatar({
    super.key,
    this.imageBytes,
    this.size = 64,
    this.shape = ExpressiveShape.circle,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final Widget avatarContent = imageBytes != null
        ? ClipPath(
            clipper: _ExpressiveShapeClipper(shape),
            child: Image.memory(
              imageBytes!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          )
        : Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              shape: shape == ExpressiveShape.circle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: shape == ExpressiveShape.roundedSquare 
                  ? BorderRadius.circular(size * 0.25)
                  : shape == ExpressiveShape.squircle
                      ? BorderRadius.circular(size * 0.35)
                      : null,
            ),
            child: Icon(
              Icons.person,
              size: size * 0.6,
              color: colorScheme.onSurfaceVariant,
            ),
          );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: shape == ExpressiveShape.circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: _getBorderRadius(),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _ExpressiveShapePainter(shape, backgroundColor),
        child: avatarContent,
      ),
    );
  }

  BorderRadius? _getBorderRadius() {
    switch (shape) {
      case ExpressiveShape.roundedSquare:
        return BorderRadius.circular(size * 0.25);
      case ExpressiveShape.squircle:
        return BorderRadius.circular(size * 0.35);
      case ExpressiveShape.diamond:
      case ExpressiveShape.blob1:
      case ExpressiveShape.blob2:
      case ExpressiveShape.star:
      case ExpressiveShape.heart:
        return null;
      default:
        return null;
    }
  }
}

class _ExpressiveShapeClipper extends CustomClipper<Path> {
  final ExpressiveShape shape;

  _ExpressiveShapeClipper(this.shape);

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
        _createBlobPath(path, size, 0.4);
        break;
      case ExpressiveShape.blob2:
        _createBlobPath(path, size, 0.6);
        break;
      case ExpressiveShape.star:
        _createStarPath(path, size, 5);
        break;
      case ExpressiveShape.heart:
        _createHeartPath(path, size);
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
      final randomRadius = radius * (0.8 + irregularity * Random().nextDouble());
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
    final innerRadius = outerRadius * 0.4;

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