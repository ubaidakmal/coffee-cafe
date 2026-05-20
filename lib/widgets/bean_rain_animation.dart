import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class BeanRainAnimation extends StatefulWidget {
  const BeanRainAnimation({
    this.beanCount = 32,
    this.groundYFactor = 0.68,
    this.duration = const Duration(milliseconds: 3200),
    this.autoStart = true,
    this.onCompleted,
    super.key,
  });

  final int beanCount;
  final double groundYFactor;
  final Duration duration;
  final bool autoStart;
  final VoidCallback? onCompleted;

  @override
  State<BeanRainAnimation> createState() => _BeanRainAnimationState();
}

class _BeanRainAnimationState extends State<BeanRainAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_BeanParticle> _beans;
  bool _didComplete = false;

  static const double _startY = -120;

  @override
  void initState() {
    super.initState();
    _beans = _createBeans(widget.beanCount);
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener(_handleStatus);

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant BeanRainAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted && !_didComplete) {
      _didComplete = true;
      widget.onCompleted?.call();
    }
  }

  List<_BeanParticle> _createBeans(int count) {
    final random = Random(7);

    return List.generate(count, (index) {
      final column = index % 7;
      final row = index ~/ 7;
      final centerSpread = (column - 3) * 0.055 + (row.isEven ? 0 : 0.028);

      return _BeanParticle(
        startX: random.nextDouble() * 1.18 - 0.09,
        endX: (0.5 + centerSpread + (random.nextDouble() - 0.5) * 0.045).clamp(
          0.16,
          0.84,
        ),
        size: 18 + random.nextDouble() * 17,
        initialRotation: random.nextDouble() * pi * 2,
        rotationAmount:
            (random.nextBool() ? 1 : -1) *
            (pi * (0.65 + random.nextDouble() * 1.5)),
        delay: random.nextDouble() * 0.14 + (index / count) * 0.1,
        fallDuration: 0.27 + random.nextDouble() * 0.1,
        bounceHeight: 18 + random.nextDouble() * 34,
        finalOffsetY: random.nextDouble() * 9 - 3,
      );
    });
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final groundY = height * widget.groundYFactor;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                for (final bean in _beans)
                  _BeanParticleView(
                    bean: bean,
                    progress: _controller.value,
                    width: width,
                    groundY: groundY,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _BeanParticleView extends StatelessWidget {
  const _BeanParticleView({
    required this.bean,
    required this.progress,
    required this.width,
    required this.groundY,
  });

  final _BeanParticle bean;
  final double progress;
  final double width;
  final double groundY;

  static const String _beanPath = 'assets/images/bean.png';
  static const double _startY = _BeanRainAnimationState._startY;
  static const double _firstBounceDuration = 0.12;
  static const double _secondBounceDuration = 0.1;
  static const double _settleDuration = 0.08;

  @override
  Widget build(BuildContext context) {
    final elapsed = progress - bean.delay;
    final activeDuration =
        bean.fallDuration + _firstBounceDuration + _secondBounceDuration;
    final travelProgress = (elapsed / activeDuration).clamp(0.0, 1.0);
    final opacity = (elapsed / 0.08).clamp(0.0, 1.0);
    final x = lerpDouble(
      bean.startX * width,
      bean.endX * width,
      Curves.easeOut.transform(travelProgress),
    )!;
    final y = _calculateY(elapsed);
    final distanceToGround = ((groundY - y).abs() / 150).clamp(0.0, 1.0);
    final groundedFactor = 1 - distanceToGround;
    final rotation =
        bean.initialRotation + bean.rotationAmount * travelProgress;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Transform.translate(
          offset: Offset(x - bean.size * 0.35, groundY + bean.size * 0.5),
          child: Transform.scale(
            scaleX: 0.55 + groundedFactor * 0.55,
            scaleY: 0.36 + groundedFactor * 0.22,
            child: Opacity(
              opacity: opacity * (0.08 + groundedFactor * 0.26),
              child: Container(
                width: bean.size * 1.25,
                height: bean.size * 0.36,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(bean.size),
                ),
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(x - bean.size / 2, y),
          child: Transform.rotate(
            angle: rotation,
            child: Opacity(
              opacity: opacity,
              child: Image.asset(
                _beanPath,
                width: bean.size,
                height: bean.size * 1.36,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateY(double elapsed) {
    if (elapsed <= 0) {
      return _startY;
    }

    if (elapsed <= bean.fallDuration) {
      final phase = Curves.easeIn.transform(
        (elapsed / bean.fallDuration).clamp(0.0, 1.0),
      );
      return lerpDouble(_startY, groundY, phase)!;
    }

    final firstBounceStart = bean.fallDuration;
    final firstBounceEnd = firstBounceStart + _firstBounceDuration;
    if (elapsed <= firstBounceEnd) {
      final phase = ((elapsed - firstBounceStart) / _firstBounceDuration).clamp(
        0.0,
        1.0,
      );
      return groundY - sin(phase * pi) * bean.bounceHeight;
    }

    final secondBounceStart = firstBounceEnd;
    final secondBounceEnd = secondBounceStart + _secondBounceDuration;
    if (elapsed <= secondBounceEnd) {
      final phase = ((elapsed - secondBounceStart) / _secondBounceDuration)
          .clamp(0.0, 1.0);
      return groundY - sin(phase * pi) * bean.bounceHeight * 0.35;
    }

    final settlePhase = ((elapsed - secondBounceEnd) / _settleDuration).clamp(
      0.0,
      1.0,
    );
    return lerpDouble(groundY, groundY + bean.finalOffsetY, settlePhase)!;
  }
}

class _BeanParticle {
  const _BeanParticle({
    required this.startX,
    required this.endX,
    required this.size,
    required this.initialRotation,
    required this.rotationAmount,
    required this.delay,
    required this.fallDuration,
    required this.bounceHeight,
    required this.finalOffsetY,
  });

  final double startX;
  final double endX;
  final double size;
  final double initialRotation;
  final double rotationAmount;
  final double delay;
  final double fallDuration;
  final double bounceHeight;
  final double finalOffsetY;
}
