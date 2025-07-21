import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatefulWidget {
  final Uint8List? currentAvatar;
  final Function(Uint8List) onAvatarChanged;
  final double size;

  const AvatarPicker({
    Key? key,
    this.currentAvatar,
    required this.onAvatarChanged,
    this.size = 120,
  }) : super(key: key);

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
      
      widget.onAvatarChanged(bytes);
      
      /*
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CustomAvatarCropper(
            imageData: bytes,
            onCropped: (croppedBytes) {
              widget.onAvatarChanged(croppedBytes);
            },
          ),
        ),
      );
      */
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
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

// Оставлен класс для обрезки, но он сейчас не используется
class CustomAvatarCropper extends StatefulWidget {
  final Uint8List imageData;
  final Function(Uint8List) onCropped;

  const CustomAvatarCropper({
    required this.imageData,
    required this.onCropped,
    Key? key,
  }) : super(key: key);

  @override
  _CustomAvatarCropperState createState() => _CustomAvatarCropperState();
}

class _CustomAvatarCropperState extends State<CustomAvatarCropper> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _previousOffset = Offset.zero;
  late ui.Image _image;
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    _image = await decodeImageFromList(widget.imageData);
    final imageRatio = _image.width / _image.height;
    final viewRatio = 300 / 300;
    
    if (imageRatio > viewRatio) {
      _scale = 300 / _image.width;
    } else {
      _scale = 300 / _image.height;
    }
    
    setState(() {
      _isImageLoaded = true;
    });
  }

  Future<Uint8List> _cropImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    final size = 200.0;

    final clipPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size / 2, size / 2),
        radius: size / 2,
      ));
    canvas.clipPath(clipPath);

    final scaledImageWidth = _image.width * _scale;
    final scaledImageHeight = _image.height * _scale;
    
    double srcLeft = (scaledImageWidth - 300) / 2 - _offset.dx * _scale;
    double srcTop = (scaledImageHeight - 300) / 2 - _offset.dy * _scale;
    
    double maxLeft = _image.width - 300 / _scale;
    double maxTop = _image.height - 300 / _scale;
    
    srcLeft = srcLeft.clamp(0, maxLeft > 0 ? maxLeft : 0);
    srcTop = srcTop.clamp(0, maxTop > 0 ? maxTop : 0);
    
    final srcWidth = 300 / _scale;
    final srcHeight = 300 / _scale;
    
    final srcRect = Rect.fromLTWH(
      srcLeft,
      srcTop,
      srcWidth > _image.width ? _image.width.toDouble() : srcWidth,
      srcHeight > _image.height ? _image.height.toDouble() : srcHeight,
    );

    canvas.drawImageRect(
      _image,
      srcRect,
      Rect.fromLTWH(0, 0, size, size),
      paint,
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isImageLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Обрезать аватарку'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              final cropped = await _cropImage();
              widget.onCropped(cropped);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: GestureDetector(
        onScaleStart: (details) {
          _previousScale = _scale;
          _previousOffset = _offset;
        },
        onScaleUpdate: (details) {
          setState(() {
            _scale = (_previousScale * details.scale).clamp(0.5, 3.0);
            _offset = _previousOffset + details.focalPointDelta;
          });
        },
        child: Center(
          child: Transform.scale(
            scale: _scale,
            child: Transform.translate(
              offset: _offset,
              child: ClipOval(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: CustomPaint(
                    painter: _ImagePainter(_image, _scale, _offset),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePainter extends CustomPainter {
  final ui.Image image;
  final double scale;
  final Offset offset;

  _ImagePainter(this.image, this.scale, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final scaledWidth = image.width * scale;
    final scaledHeight = image.height * scale;

    final dx = (size.width - scaledWidth) / 2 + offset.dx;
    final dy = (size.height - scaledHeight) / 2 + offset.dy;
    
    final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(dx, dy, scaledWidth, scaledHeight);
    
    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _ImagePainter || 
           oldDelegate.scale != scale || 
           oldDelegate.offset != offset;
  }
}