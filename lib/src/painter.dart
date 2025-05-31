import 'package:flutter/material.dart';
import 'particle.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Draw the particle fill
      final fillPaint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(particle.position.dx, particle.position.dy, 2, 2),
        fillPaint,
      );

      // Draw the grey border
      final borderPaint = Paint()
        ..color = Colors.grey.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawRect(
        Rect.fromLTWH(particle.position.dx, particle.position.dy, 2, 2),
        borderPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
