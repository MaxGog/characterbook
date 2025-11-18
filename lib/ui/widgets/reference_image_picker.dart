import 'dart:typed_data';

import 'package:flutter/material.dart';

class ReferenceImagePicker extends StatelessWidget {
  final Uint8List? imageBytes;
  final VoidCallback onPickImage;
  final String title;

  const ReferenceImagePicker({
    super.key,
    this.imageBytes,
    required this.onPickImage,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          title,
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPickImage,
          child: Ink(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              image: imageBytes != null
                  ? DecorationImage(
                      image: MemoryImage(imageBytes!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageBytes == null
                ? Icon(
                    Icons.add_a_photo,
                    size: 40,
                    color: colorScheme.onSurfaceVariant,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}