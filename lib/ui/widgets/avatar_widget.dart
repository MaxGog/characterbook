import 'dart:typed_data';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final Uint8List? imageBytes;
  final double size;
  final IconData defaultIcon;
  final Color? backgroundColor;
  final Color? iconColor;
  final ShapeBorder? shape;
  final BoxFit fit;

  const AvatarWidget({
    super.key,
    this.imageBytes,
    required this.size,
    this.defaultIcon = Icons.person,
    this.backgroundColor,
    this.iconColor,
    this.shape,
    this.fit = BoxFit.cover,
  });

  factory AvatarWidget.character({
    Key? key,
    required Uint8List? imageBytes,
    required double size,
    ShapeBorder? shape,
    BoxFit fit = BoxFit.cover,
  }) {
    return AvatarWidget(
      key: key,
      imageBytes: imageBytes,
      size: size,
      defaultIcon: Icons.person,
      shape: shape,
      fit: fit,
    );
  }

  factory AvatarWidget.race({
    Key? key,
    required Uint8List? imageBytes,
    double size = 24,
    ShapeBorder? shape,
    BoxFit fit = BoxFit.cover,
  }) {
    return AvatarWidget(
      key: key,
      imageBytes: imageBytes,
      size: size,
      defaultIcon: Icons.emoji_people,
      shape: shape,
      fit: fit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor =
        backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final iconClr = iconColor ?? theme.colorScheme.onSurfaceVariant;

    if (shape == null) {
      return imageBytes != null
          ? CircleAvatar(
              backgroundImage: MemoryImage(imageBytes!),
              radius: size,
            )
          : CircleAvatar(
              radius: size,
              backgroundColor: bgColor,
              child: Icon(
                defaultIcon,
                size: size * (defaultIcon == Icons.person ? 0.7 : 1.0),
                color: iconClr,
              ),
            );
    }

    final double containerSize = size * 2;

    return Container(
      width: containerSize,
      height: containerSize,
      decoration: ShapeDecoration(
        shape: shape!,
        color: imageBytes == null ? bgColor : null,
        image: imageBytes != null
            ? DecorationImage(
                image: MemoryImage(imageBytes!),
                fit: fit,
              )
            : null,
      ),
      child: imageBytes == null
          ? Icon(
              defaultIcon,
              size: containerSize * 0.5,
              color: iconClr,
            )
          : null,
    );
  }
}
