import 'dart:math' as math;

import 'package:flutter/material.dart';

class OrganicDoorReveal extends StatefulWidget {
  const OrganicDoorReveal({
    required this.child,
    required this.open,
    this.duration = const Duration(milliseconds: 1400),
    this.onCompleted,
    super.key,
  });

  final Widget child;
  final bool open;
  final Duration duration;
  final VoidCallback? onCompleted;

  @override
  State<OrganicDoorReveal> createState() => _OrganicDoorRevealState();
}

class _OrganicDoorRevealState extends State<OrganicDoorReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener(_handleStatus);
    if (widget.open) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant OrganicDoorReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (!oldWidget.open && widget.open) {
      _controller.forward();
    }
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      widget.onCompleted?.call();
    }
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_handleStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = Curves.easeInOutCubic.transform(_controller.value);

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final travel = width * 0.58 * progress;
            final crackAmount = 0.8 + progress * 0.45;

            return Stack(
              fit: StackFit.expand,
              children: [
                _DoorPanel(
                  isLeft: true,
                  progress: progress,
                  travel: travel,
                  crackAmount: crackAmount,
                  child: widget.child,
                ),
                _DoorPanel(
                  isLeft: false,
                  progress: progress,
                  travel: travel,
                  crackAmount: crackAmount,
                  child: widget.child,
                ),
                IgnorePointer(
                  child: Opacity(
                    opacity: (1 - progress * 0.85).clamp(0.0, 1.0),
                    child: CustomPaint(
                      painter: _OrganicSeamPainter(progress: progress),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _DoorPanel extends StatelessWidget {
  const _DoorPanel({
    required this.isLeft,
    required this.progress,
    required this.travel,
    required this.crackAmount,
    required this.child,
  });

  final bool isLeft;
  final double progress;
  final double travel;
  final double crackAmount;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final direction = isLeft ? -1.0 : 1.0;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0009)
      ..rotateY(direction * 0.16 * progress);

    return RepaintBoundary(
      child: Transform.translate(
        offset: Offset(direction * travel, 0),
        child: Transform(
          alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          transform: transform,
          child: Transform.rotate(
            angle: direction * 0.035 * progress,
            alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            child: ClipPath(
              clipper: OrganicDoorClipper(
                isLeft: isLeft,
                crackAmount: crackAmount,
                softness: 1,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class OrganicDoorClipper extends CustomClipper<Path> {
  OrganicDoorClipper({
    required this.isLeft,
    required this.crackAmount,
    required this.softness,
  });

  final bool isLeft;
  final double crackAmount;
  final double softness;

  static const List<double> _offsets = [-8, 12, -5, 16, -10, 7, -14, 10, -6];

  @override
  Path getClip(Size size) {
    final crack = _crackPoints(size, crackAmount);
    final path = Path();

    if (isLeft) {
      path
        ..moveTo(0, 0)
        ..lineTo(crack.first.dx, crack.first.dy);
      _addSmoothCrack(path, crack);
      path
        ..lineTo(0, size.height)
        ..close();
    } else {
      path
        ..moveTo(crack.first.dx, crack.first.dy)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(crack.last.dx, crack.last.dy);
      _addSmoothCrack(path, crack.reversed.toList());
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(covariant OrganicDoorClipper oldClipper) {
    return oldClipper.isLeft != isLeft ||
        oldClipper.crackAmount != crackAmount ||
        oldClipper.softness != softness;
  }
}

class _OrganicSeamPainter extends CustomPainter {
  const _OrganicSeamPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final crack = _crackPoints(size, 1 + progress * 0.35);
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8
      ..color = const Color(0xFFC9922A).withValues(alpha: 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    final warmLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.6
      ..color = const Color(0xFFF5E6CC).withValues(alpha: 0.48);
    final shadow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5
      ..color = Colors.black.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = Path()..moveTo(crack.first.dx, crack.first.dy);
    _addSmoothCrack(path, crack);

    canvas
      ..drawPath(path, shadow)
      ..drawPath(path, glow)
      ..drawPath(path, warmLine);
  }

  @override
  bool shouldRepaint(covariant _OrganicSeamPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

List<Offset> _crackPoints(Size size, double crackAmount) {
  const offsets = OrganicDoorClipper._offsets;
  final centerX = size.width / 2;
  final scale = (size.width * 0.018).clamp(7.0, 18.0) * crackAmount;

  return List.generate(offsets.length, (index) {
    final y = size.height * index / (offsets.length - 1);
    final wave = math.sin(index * 1.2) * scale * 0.24;
    return Offset(centerX + offsets[index] / 16 * scale + wave, y);
  });
}

void _addSmoothCrack(Path path, List<Offset> points) {
  for (var i = 1; i < points.length; i++) {
    final previous = points[i - 1];
    final current = points[i];
    final control = Offset(
      previous.dx,
      previous.dy + (current.dy - previous.dy) * 0.58,
    );
    path.quadraticBezierTo(control.dx, control.dy, current.dx, current.dy);
  }
}
