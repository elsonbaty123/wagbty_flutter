import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late final List<AnimatedParticle> _particles;
  late final AnimationController _controller;
  final int _particleCount = 15;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(
      _particleCount,
      (index) => AnimatedParticle(
        size: _random.nextDouble() * 40 + 20,
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: _random.nextDouble() * 0.5 + 0.1,
        angle: _random.nextDouble() * 2 * pi,
        color: _getRandomColor(),
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getRandomColor() {
    final colors = [
      Colors.orange.shade100.withOpacity(0.3),
      Colors.orange.shade200.withOpacity(0.3),
      Colors.orange.shade300.withOpacity(0.3),
      Colors.orange.shade400.withOpacity(0.3),
      Colors.orange.shade500.withOpacity(0.3),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _BackgroundPainter(
              particles: _particles,
              time: _controller.value * 2 * pi,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final List<AnimatedParticle> particles;
  final double time;

  _BackgroundPainter({
    required this.particles,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw gradient background
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.orange.shade50,
        Colors.orange.shade100,
      ],
    );
    
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Draw particles
    for (final particle in particles) {
      particle.update(time);
      particle.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) => true;
}

class AnimatedParticle {
  final double size;
  double x;
  double y;
  final double speed;
  double angle;
  final Color color;
  final double baseSize;
  double timeOffset;
  final Random _random = Random();

  AnimatedParticle({
    required this.size,
    required this.x,
    required this.y,
    required this.speed,
    required this.angle,
    required this.color,
  })  : baseSize = size,
        timeOffset = _random.nextDouble() * 2 * pi;

  void update(double time) {
    // Update position
    x += cos(angle) * 0.002 * speed;
    y += sin(angle) * 0.002 * speed;

    // Bounce off edges
    if (x < -0.2) {
      x = -0.2;
      angle = _random.nextDouble() * pi - pi / 2;
    } else if (x > 1.2) {
      x = 1.2;
      angle = _random.nextDouble() * pi + pi / 2;
    }

    if (y < -0.2) {
      y = -0.2;
      angle = _random.nextDouble() * pi;
    } else if (y > 1.2) {
      y = 1.2;
      angle = _random.nextDouble() * pi + pi;
    }
  }

  void draw(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Calculate pulsing size
    final pulseSize = baseSize * (1 + 0.2 * sin(timeOffset + time * 2));

    // Draw particle
    canvas.drawCircle(
      Offset(x * size.width, y * size.height),
      pulseSize,
      paint,
    );
  }
}
