import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

import 'package:widget_exploder/src/exploder.controller.dart';
import 'package:widget_exploder/src/painter.dart';
import 'package:widget_exploder/src/particle.dart';

class Exploder extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final ExploderController? controller;
  final int particalSize;

  const Exploder({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.controller,
    this.particalSize = 8,
  });

  @override
  State<Exploder> createState() => _ExploderState();
}

class _ExploderState extends State<Exploder> with SingleTickerProviderStateMixin {
  final _key = GlobalKey();
  final _childKey = GlobalKey();
  ui.Image? _image;
  List<Particle> _particles = [];
  late AnimationController _controller;
  bool _dissolving = false;
  Size? _widgetSize;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleControllerUpdate);
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(_tick)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.controller?.animationComplete();
        }
      });
  }

  void _handleControllerUpdate() {
    if (widget.controller == null) return;

    if (widget.controller!.trigger && !_dissolving) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startDissolve());
    }

    if (widget.controller!.reset) {
      setState(() {
        _image = null;
        _particles.clear();
        _dissolving = false;
        _controller.reset();
      });
      widget.controller?.clearTrigger();
    }
  }

  void _tick() {
    setState(() {
      for (final p in _particles) {
        p.update(_particles);
      }
    });
  }

  Future<void> _startDissolve() async {
    if (_dissolving) return;
    _dissolving = true;

    // Get the child widget size first
    final childBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (childBox == null) return;

    // Get the size after layout
    childBox.layout(childBox.constraints);
    _widgetSize = childBox.size;
    if (_widgetSize == null) return;

    RenderRepaintBoundary boundary = _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final data = byteData!.buffer.asUint8List();

    final width = image.width;
    final height = image.height;

    // Calculate scale factors
    final scaleX = _widgetSize!.width / width;
    final scaleY = _widgetSize!.height / height;

    final pixels = <Particle>[];

    // Calculate the center bottom point
    final centerX = _widgetSize!.width / 2;
    final bottomY = _widgetSize!.height;

    for (int y = 0; y < height; y += widget.particalSize) {
      for (int x = 0; x < width; x += widget.particalSize) {
        final index = (y * width + x) * 4;
        if (index + 3 >= data.length) continue;

        final r = data[index];
        final g = data[index + 1];
        final b = data[index + 2];
        final a = data[index + 3];
        final color = Color.fromARGB(a, r, g, b);

        // Scale the position to match widget size
        final scaledX = x * scaleX;
        final scaledY = y * scaleY;

        // Calculate direction from center bottom
        final dirX = scaledX - centerX;
        final dirY = scaledY - bottomY;
        final distance = math.sqrt(dirX * dirX + dirY * dirY);

        // Normalize direction and add some randomness
        final normalizedX = dirX / distance;
        final normalizedY = dirY / distance;
        final randomSpread = (math.Random().nextDouble() - 0.5) * 0.5; // Random spread factor

        // Calculate initial velocity with upward bias and spread
        final speed = 5.0 + math.Random().nextDouble() * 3.0; // Random speed between 5 and 8
        final velocityX = (normalizedX + randomSpread) * speed;
        final velocityY = (normalizedY - 2.0) * speed; // Negative to shoot upward

        pixels.add(
          Particle(
            position: Offset(centerX, bottomY), // Start from bottom center
            velocity: Offset(velocityX, velocityY),
            color: color,
            originalHeight: _widgetSize!.height,
            originalWidth: _widgetSize!.width,
          ),
        );
      }
    }

    setState(() {
      _particles = pixels;
      _image = image;
    });

    _controller.forward();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return RepaintBoundary(
        key: _key,
        child: widget.child,
      );
    }

    if (_widgetSize == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: _widgetSize!.width,
      height: _widgetSize!.height,
      clipBehavior: Clip.none,
      child: CustomPaint(
        size: Size(_widgetSize!.width, _widgetSize!.height),
        painter: ParticlePainter(_particles),
      ),
    );
  }
}
