import 'dart:math' as math;

import 'package:flutter/material.dart';

class SplitBean extends StatelessWidget {
  const SplitBean({required this.controller, required this.size, super.key});

  final AnimationController controller;
  final double size;

  static const String _beanPath = 'assets/images/bean.png';

  @override
  Widget build(BuildContext context) {
    final height = size * 1.35;
    final splitAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubicEmphasized,
    );

    return AnimatedBuilder(
      animation: splitAnimation,
      builder: (context, child) {
        final progress = splitAnimation.value;
        final maxTravel = size * 0.38;
        final travel = maxTravel * progress;
        final lift = -size * 0.055 * math.sin(progress * math.pi);
        final rotation = 0.2 * progress;

        return SizedBox(
          width: size + maxTravel * 2,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                left: maxTravel,
                top: 0,
                width: size / 2,
                height: height,
                child: Transform.translate(
                  offset: Offset(-travel, lift),
                  child: Transform.rotate(
                    angle: -rotation,
                    alignment: Alignment.centerRight,
                    child: _BeanHalf(
                      imagePath: _beanPath,
                      alignment: Alignment.centerLeft,
                      fullWidth: size,
                      height: height,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: maxTravel,
                top: 0,
                width: size / 2,
                height: height,
                child: Transform.translate(
                  offset: Offset(travel, lift),
                  child: Transform.rotate(
                    angle: rotation,
                    alignment: Alignment.centerLeft,
                    child: _BeanHalf(
                      imagePath: _beanPath,
                      alignment: Alignment.centerRight,
                      fullWidth: size,
                      height: height,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BeanHalf extends StatelessWidget {
  const _BeanHalf({
    required this.imagePath,
    required this.alignment,
    required this.fullWidth,
    required this.height,
  });

  final String imagePath;
  final Alignment alignment;
  final double fullWidth;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: OverflowBox(
        alignment: alignment,
        minWidth: fullWidth,
        maxWidth: fullWidth,
        minHeight: height,
        maxHeight: height,
        child: Image.asset(
          imagePath,
          width: fullWidth,
          height: height,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
