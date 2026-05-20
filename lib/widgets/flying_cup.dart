import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'hover_reveal_cup.dart';

class FlyingCup extends StatelessWidget {
  const FlyingCup({
    required this.imagePath,
    required this.revealImagePath,
    required this.size,
    required this.rotation,
    required this.delay,
    required this.semanticLabel,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.revealed = false,
    this.onRevealToggle,
    this.revealScale = 1.08,
    super.key,
  });

  final String imagePath;
  final String revealImagePath;
  final String semanticLabel;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final double rotation;
  final int delay;
  final bool revealed;
  final ValueChanged<bool>? onRevealToggle;
  final double revealScale;

  @override
  Widget build(BuildContext context) {
    final hitPadding = size * 0.18;

    return Positioned(
      top: top == null ? null : top! - hitPadding,
      bottom: bottom == null ? null : bottom! - hitPadding,
      left: left == null ? null : left! - hitPadding,
      right: right == null ? null : right! - hitPadding,
      child:
          SizedBox(
                width: size + hitPadding * 2,
                height: size * 1.14 + hitPadding * 2,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: hitPadding,
                      top: hitPadding,
                      child: Transform.rotate(
                        angle: rotation,
                        child: Container(
                          width: size,
                          height: size * 1.14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(size * 0.08),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF2A1005,
                                ).withValues(alpha: 0.22),
                                blurRadius: size * 0.16,
                                offset: Offset(0, size * 0.08),
                              ),
                            ],
                          ),
                          child: HoverRevealCup(
                            normalSrc: imagePath,
                            revealSrc: revealImagePath,
                            semanticLabel: semanticLabel,
                            size: size,
                            revealed: revealed,
                            revealScale: revealScale,
                            onRevealToggle: onRevealToggle,
                          ),
                        ),
                      ),
                    ),
                  ],
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
