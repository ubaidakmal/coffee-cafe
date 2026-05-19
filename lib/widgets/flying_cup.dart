import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FlyingCup extends StatelessWidget {
  const FlyingCup({
    required this.imagePath,
    required this.size,
    required this.rotation,
    required this.delay,
    this.top,
    this.bottom,
    this.left,
    this.right,
    super.key,
  });

  final String imagePath;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final double rotation;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child:
          Transform.rotate(
                angle: rotation,
                child: Container(
                  width: size,
                  height: size * 1.14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size * 0.08),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2A1005).withValues(alpha: 0.22),
                        blurRadius: size * 0.16,
                        offset: Offset(0, size * 0.08),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              )
              .animate(delay: delay.ms)
              .fadeIn(duration: 560.ms, curve: Curves.easeOut)
              .slideX(
                begin: 1.9,
                end: 0,
                duration: 1050.ms,
                curve: Curves.easeOutBack,
              )
              .scale(
                begin: const Offset(0.86, 0.86),
                end: const Offset(1, 1),
                duration: 900.ms,
                curve: Curves.easeOutCubic,
              ),
    );
  }
}
