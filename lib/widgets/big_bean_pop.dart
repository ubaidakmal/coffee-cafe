import 'dart:math' as math;

import 'package:flutter/material.dart';

class BigBeanPop extends StatefulWidget {
  const BigBeanPop({required this.visible, required this.size, super.key});

  final bool visible;
  final double size;

  @override
  State<BigBeanPop> createState() => _BigBeanPopState();
}

class _BigBeanPopState extends State<BigBeanPop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  static const String _beanPath = 'assets/images/bean.png';

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: widget.visible ? 1 : 0),
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOutBack,
      builder: (context, progress, child) {
        final safeProgress = progress.clamp(0.0, 1.0);

        return AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final floatY =
                math.sin(_floatController.value * math.pi * 2) *
                4 *
                safeProgress;
            final scale = 0.72 + safeProgress * 0.28;

            return Opacity(
              opacity: safeProgress,
              child: Transform.translate(
                offset: Offset(0, floatY),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, widget.size * 0.48),
                      child: Transform.scale(
                        scaleX: 0.68 + safeProgress * 0.28,
                        scaleY: 0.36 + safeProgress * 0.14,
                        child: Opacity(
                          opacity: safeProgress * 0.42,
                          child: Container(
                            width: widget.size * 1.08,
                            height: widget.size * 0.22,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(widget.size),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  blurRadius: 34,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: widget.size * 1.35,
                      height: widget.size * 1.55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFC9922A,
                            ).withValues(alpha: safeProgress * 0.2),
                            blurRadius: 64,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                      scale: scale,
                      child: Image.asset(
                        _beanPath,
                        width: widget.size,
                        height: widget.size * 1.35,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
