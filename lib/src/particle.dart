import 'dart:ui';
import 'dart:math' as math;

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  bool _isPiled = false;
  final double _originalHeight;
  final double _originalWidth;
  final double mass;
  final double radius = 2.0; // Particle radius for collision detection
  final double restitution; // Bounciness factor

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required double originalHeight,
    required double originalWidth,
  })  : _originalHeight = originalHeight,
        _originalWidth = originalWidth,
        mass = 1.0 + math.Random().nextDouble() * 0.5, // Random mass between 1.0 and 1.5
        restitution = 0.7 + math.Random().nextDouble() * 0.2; // Random bounciness between 0.7 and 0.9

  void update(List<Particle> otherParticles) {
    if (_isPiled) return;

    // Apply gravity
    velocity += const Offset(0, 0.3);

    // Apply air resistance (proportional to velocity squared)
    const airResistance = 0.01;
    final speed = velocity.distance;
    if (speed > 0) {
      final resistance = velocity * (airResistance * speed);
      velocity -= resistance;
    }

    // Update position
    position += velocity;

    // Check for bottom collision with bounce
    if (position.dy >= _originalHeight) {
      position = Offset(position.dx, _originalHeight);
      velocity = Offset(velocity.dx * 0.8, -velocity.dy * restitution); // Use particle's restitution

      // If velocity is very low, consider it piled
      if (velocity.distance < 0.1) {
        _isPiled = true;
        velocity = Offset.zero;
      }
    }

    // Check for side collisions
    if (position.dx < 0) {
      position = Offset(0, position.dy);
      velocity = Offset(-velocity.dx * restitution, velocity.dy); // Use particle's restitution
    } else if (position.dx > _originalWidth) {
      position = Offset(_originalWidth, position.dy);
      velocity = Offset(-velocity.dx * restitution, velocity.dy); // Use particle's restitution
    }

    // Check for collisions with other particles
    for (final other in otherParticles) {
      if (other == this) continue;

      final distance = (position - other.position).distance;
      if (distance < radius * 2 && distance > 0) {
        // Collision detected - calculate collision response
        final normal = (position - other.position) / distance;
        final relativeVelocity = velocity - other.velocity;
        final relativeSpeed = relativeVelocity.dx * normal.dx + relativeVelocity.dy * normal.dy;

        // Only resolve if particles are moving toward each other
        if (relativeSpeed < 0) {
          // Calculate impulse using average restitution of both particles
          final avgRestitution = (restitution + other.restitution) / 2;
          final totalMass = 1 / mass + 1 / other.mass;
          if (totalMass > 0) {
            final impulse = -(1 + avgRestitution) * relativeSpeed / totalMass;

            // Apply impulse
            velocity += normal * (impulse / mass);
            other.velocity -= normal * (impulse / other.mass);

            // Move particles apart to prevent sticking
            final overlap = radius * 2 - distance;
            position += normal * (overlap * 0.5);
            other.position -= normal * (overlap * 0.5);
          }
        }
      }
    }
  }
}
