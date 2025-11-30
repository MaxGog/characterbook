import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_image/crop_image.dart';
import 'package:characterbook/ui/widgets/appbar/common_edit_app_bar.dart';
import 'package:characterbook/generated/l10n.dart';

class AvatarPicker extends StatefulWidget {
  final Uint8List? currentAvatar;
  final Function(Uint8List) onAvatarChanged;
  final double size;

  const AvatarPicker({
    super.key,
    this.currentAvatar,
    required this.onAvatarChanged,
    this.size = 120,
  });

  @override
  _AvatarPickerState createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final bytes = await image.readAsBytes();

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AvatarCropper(
            imageData: bytes,
            onCropped: (croppedBytes) {
              widget.onAvatarChanged(croppedBytes);
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final s = S.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.avatar_picker_error(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: widget.size,
        backgroundImage: widget.currentAvatar != null
            ? MemoryImage(widget.currentAvatar!)
            : null,
        child: widget.currentAvatar == null
            ? Icon(Icons.add_a_photo, size: widget.size * 0.5)
            : null,
      ),
    );
  }
}

class AvatarCropper extends StatefulWidget {
  final Uint8List imageData;
  final Function(Uint8List) onCropped;

  const AvatarCropper({
    required this.imageData,
    required this.onCropped,
    super.key,
  });

  @override
  _AvatarCropperState createState() => _AvatarCropperState();
}

class _AvatarCropperState extends State<AvatarCropper> {
  final _cropController = CropController(aspectRatio: 1);
  final _cropImageKey = GlobalKey();
  late ui.Image _decodedImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    _decodedImage = await _decodeImage(widget.imageData);
  }

  Future<ui.Image> _decodeImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<Uint8List> _cropImage(BuildContext context) async {
    final cropRect = _cropController.crop;
    final renderBox = _cropImageKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      final s = S.of(context);
      throw Exception(s.avatar_crop_widget_size_error);
    }

    const paddingSize = 20.0;
    final imageWidth = _decodedImage.width.toDouble();
    final imageHeight = _decodedImage.height.toDouble();
    final cropAreaWidth = renderBox.size.width - paddingSize * 2;
    final cropAreaHeight = renderBox.size.height - paddingSize * 2;

    final imageAspect = imageWidth / imageHeight;
    final cropAreaAspect = cropAreaWidth / cropAreaHeight;

    final scale = imageAspect > cropAreaAspect
        ? cropAreaWidth / imageWidth
        : cropAreaHeight / imageHeight;

    final imageOffsetX = imageAspect > cropAreaAspect
        ? paddingSize
        : paddingSize + (cropAreaWidth - imageWidth * scale) / 2;

    final imageOffsetY = imageAspect > cropAreaAspect
        ? paddingSize + (cropAreaHeight - imageHeight * scale) / 2
        : paddingSize;

    final cropXInWidget = cropRect.left * cropAreaWidth + paddingSize;
    final cropYInWidget = cropRect.top * cropAreaHeight + paddingSize;
    final cropWInPixels = cropRect.width * cropAreaWidth;
    final cropHInPixels = cropRect.height * cropAreaHeight;

    final cropX = cropXInWidget - imageOffsetX;
    final cropY = cropYInWidget - imageOffsetY;

    final sourceLeft = (cropX / scale).clamp(0.0, imageWidth);
    final sourceTop = (cropY / scale).clamp(0.0, imageHeight);
    final sourceWidth = (cropWInPixels / scale).clamp(0.0, imageWidth - sourceLeft);
    final sourceHeight = (cropHInPixels / scale).clamp(0.0, imageHeight - sourceTop);

    if (sourceWidth <= 0 || sourceHeight <= 0) {
      final s = S.of(context);
      throw Exception(s.avatar_crop_coordinates_error);
    }

    final sourceRect = Rect.fromLTWH(sourceLeft, sourceTop, sourceWidth, sourceHeight);
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    canvas.drawImageRect(
      _decodedImage,
      sourceRect,
      const Rect.fromLTWH(0, 0, 200, 200),
      Paint(),
    );

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(200, 200);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _confirmCrop() async {
    try {
      final croppedBytes = await _cropImage(context);
      widget.onCropped(croppedBytes);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      final s = S.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.avatar_crop_error(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: CommonEditAppBar(
        title: s.avatar_crop_title,
        onSave: _confirmCrop,
        saveTooltip: s.save,
      ),
      body: Center(
        child: CropImage(
          key: _cropImageKey,
          controller: _cropController,
          image: Image.memory(widget.imageData),
          paddingSize: 20.0,
        ),
      ),
    );
  }
}
