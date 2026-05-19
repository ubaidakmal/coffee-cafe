import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/split_bean.dart';
import 'reveal_screen.dart';

class HeroScreen extends StatefulWidget {
  const HeroScreen({super.key});

  @override
  State<HeroScreen> createState() => _HeroScreenState();
}

class _HeroScreenState extends State<HeroScreen> with TickerProviderStateMixin {
  late final AnimationController _fallController;
  late final AnimationController _idleController;
  late final AnimationController _splitController;
  Timer? _introTimer;
  bool _splitStarted = false;
  bool _showIntroOverlay = true;

  static const Color _espresso = Color(0xFF180800);

  @override
  void initState() {
    super.initState();
    _fallController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2700),
    )..addStatusListener(_handleFallStatus);
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
    _splitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..addStatusListener(_handleAnimationStatus);

    _fallController.forward();
  }

  void _handleFallStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      _introTimer = Timer(const Duration(milliseconds: 1450), _startSplit);
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _showIntroOverlay && mounted) {
      setState(() {
        _showIntroOverlay = false;
      });
    }
  }

  void _startSplit() {
    if (_splitStarted || !mounted) {
      return;
    }

    _introTimer?.cancel();
    if (_fallController.value < 1) {
      _fallController.value = 1;
    }
    setState(() {
      _splitStarted = true;
    });
    _splitController.forward();
  }

  @override
  void dispose() {
    _introTimer?.cancel();
    _fallController
      ..removeStatusListener(_handleFallStatus)
      ..dispose();
    _idleController.dispose();
    _splitController
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final beanWidth = (size.shortestSide * 0.54).clamp(150.0, 250.0);

    return Scaffold(
      backgroundColor: _espresso,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_splitStarted)
            const RevealScreen(initialDelay: 640)
          else
            const ColoredBox(color: _espresso),
          if (_showIntroOverlay)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _startSplit,
              child: _SplitIntroOverlay(
                splitController: _splitController,
                fallController: _fallController,
                idleController: _idleController,
                beanWidth: beanWidth,
              ),
            ),
        ],
      ),
    );
  }
}

class _SplitIntroOverlay extends StatelessWidget {
  const _SplitIntroOverlay({
    required this.splitController,
    required this.fallController,
    required this.idleController,
    required this.beanWidth,
  });

  final AnimationController splitController;
  final AnimationController fallController;
  final AnimationController idleController;
  final double beanWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final scene = _IntroScene(
          splitController: splitController,
          fallController: fallController,
          idleController: idleController,
          beanWidth: beanWidth,
        );

        return AnimatedBuilder(
          animation: splitController,
          builder: (context, child) {
            final progress = splitController.value;
            final curved = Curves.easeInOutCubicEmphasized.transform(progress);
            final travel = width * 0.62 * curved;
            final edgeOpacity = math.sin(progress * math.pi).clamp(0.0, 1.0);
            final fadeOut = (1 - ((progress - 0.82) / 0.18).clamp(0.0, 1.0));

            return Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: fadeOut,
                  child: Transform.translate(
                    offset: Offset(-travel, 0),
                    child: _IntroHalf(
                      alignment: Alignment.centerLeft,
                      width: width,
                      height: height,
                      child: scene,
                    ),
                  ),
                ),
                Opacity(
                  opacity: fadeOut,
                  child: Transform.translate(
                    offset: Offset(travel, 0),
                    child: _IntroHalf(
                      alignment: Alignment.centerRight,
                      width: width,
                      height: height,
                      child: scene,
                    ),
                  ),
                ),
                IgnorePointer(
                  child: Opacity(
                    opacity: edgeOpacity * fadeOut,
                    child: CustomPaint(
                      painter: _SoftCutPainter(progress: curved),
                      size: Size.infinite,
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

class _IntroHalf extends StatelessWidget {
  const _IntroHalf({
    required this.alignment,
    required this.width,
    required this.height,
    required this.child,
  });

  final Alignment alignment;
  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ClipRect(
        child: SizedBox(
          width: width / 2,
          height: height,
          child: OverflowBox(
            alignment: alignment,
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height,
            child: SizedBox(width: width, height: height, child: child),
          ),
        ),
      ),
    );
  }
}

class _IntroScene extends StatelessWidget {
  const _IntroScene({
    required this.splitController,
    required this.fallController,
    required this.idleController,
    required this.beanWidth,
  });

  final AnimationController splitController;
  final AnimationController fallController;
  final AnimationController idleController;
  final double beanWidth;

  static const Color _espresso = Color(0xFF180800);
  static const Color _deepBrown = Color(0xFF2A1005);
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.1),
            radius: 0.95,
            colors: [Color(0xFF3A1708), _deepBrown, _espresso],
            stops: [0.0, 0.42, 1.0],
          ),
        ),
        child: SafeArea(
          child: SizedBox.expand(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(painter: _SteamLinePainter()),
                Center(
                  child: _BeanIntroStage(
                    splitController: splitController,
                    fallController: fallController,
                    idleController: idleController,
                    beanWidth: beanWidth,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BeanIntroStage extends StatelessWidget {
  const _BeanIntroStage({
    required this.splitController,
    required this.fallController,
    required this.idleController,
    required this.beanWidth,
  });

  final AnimationController splitController;
  final AnimationController fallController;
  final AnimationController idleController;
  final double beanWidth;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final stageSize = (screen.shortestSide * 0.82).clamp(300.0, 470.0);

    return SizedBox(
      width: stageSize,
      height: stageSize * 1.18,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          fallController,
          idleController,
          splitController,
        ]),
        builder: (context, child) {
          final fallValue = fallController.value;
          final fallCurve = Curves.easeOutBack.transform(fallValue);
          final bigReveal = Curves.easeOutBack.transform(
            ((fallValue - 0.68) / 0.32).clamp(0.0, 1.0),
          );
          final splitValue = splitController.value;
          final idle = math.sin(idleController.value * math.pi * 2);
          final bigScale = bigReveal * (1 + idle * 0.018);
          final bigLift = idle * 5 * bigReveal * (1 - splitValue);
          final smallOpacity = (1 - ((fallValue - 0.72) / 0.22).clamp(0, 1))
              .toDouble();
          final beanOpacity = (1 - splitValue * 0.08).clamp(0.0, 1.0);

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              for (var i = 0; i < 14; i++)
                _FallingMiniBean(
                  index: i,
                  progress: fallCurve,
                  opacity: smallOpacity,
                  stageSize: stageSize,
                ),
              Transform.translate(
                offset: Offset(0, bigLift),
                child: Transform.scale(
                  scale: bigScale,
                  child: Opacity(
                    opacity: beanOpacity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: beanWidth * 1.34,
                          height: beanWidth * 1.58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFC9922A,
                                ).withValues(alpha: 0.18 * bigReveal),
                                blurRadius: 60,
                                spreadRadius: 14,
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.58 * bigReveal,
                                ),
                                blurRadius: 46,
                                offset: const Offset(0, 30),
                              ),
                            ],
                          ),
                        ),
                        SplitBean(controller: splitController, size: beanWidth),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FallingMiniBean extends StatelessWidget {
  const _FallingMiniBean({
    required this.index,
    required this.progress,
    required this.opacity,
    required this.stageSize,
  });

  final int index;
  final double progress;
  final double opacity;
  final double stageSize;

  static const String _beanPath = 'assets/images/bean.png';

  @override
  Widget build(BuildContext context) {
    final seed = index + 1;
    final row = index ~/ 7;
    final column = index % 7;
    final targetX =
        (column - 3) * stageSize * 0.052 + (row == 0 ? 0 : stageSize * 0.026);
    final startX = (seed % 7 - 3) * stageSize * 0.18;
    final startY = -stageSize * (0.78 + (seed % 4) * 0.16);
    final targetY = stageSize * (0.04 + row * 0.052);
    final wobble = math.sin(progress * math.pi * (1.5 + seed * 0.08)) * 14;
    final x = startX + (targetX - startX) * progress + wobble * (1 - progress);
    final y = startY + (targetY - startY) * progress;
    final bounce = math.sin(progress * math.pi * 4) * 10 * (1 - progress);
    final size = stageSize * (0.04 + (index % 3) * 0.006);

    return Transform.translate(
      offset: Offset(x, y + bounce),
      child: Transform.rotate(
        angle: -0.55 + progress * (0.7 + seed * 0.03),
        child: Opacity(
          opacity: opacity,
          child: Image.asset(
            _beanPath,
            width: size,
            height: size * 1.32,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}

class _SoftCutPainter extends CustomPainter {
  const _SoftCutPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final gap = size.width * 0.62 * progress;
    final leftEdge = centerX - gap;
    final rightEdge = centerX + gap;
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.5
      ..color = const Color(0xFFC9922A).withValues(alpha: 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    final emberPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFC9922A).withValues(alpha: 0.42)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    void drawEdge(double x) {
      final crustPath = Path()..moveTo(x, -10);

      for (var i = 0; i <= 12; i++) {
        final y = size.height * i / 12;
        final wave = math.sin(i * 1.15 + progress * 2.4) * 3;
        crustPath.lineTo(x + wave, y);
      }

      canvas.drawPath(crustPath, edgePaint);
    }

    drawEdge(leftEdge);
    drawEdge(rightEdge);

    for (var i = 0; i < 22; i++) {
      final t = i / 21;
      final y = size.height * (0.12 + 0.78 * t);
      final drift = math.sin(i * 2.31) * gap * 0.06;
      final side = i.isEven ? -1.0 : 1.0;
      final x = centerX + side * gap * (0.1 + 0.2 * ((i % 7) / 7)) + drift;
      final radius = 1.4 + (i % 4) * 0.34;

      canvas.drawCircle(
        Offset(x, y + math.cos(i * 1.43) * 16),
        radius,
        emberPaint..color = const Color(0xFFC9922A).withValues(alpha: 0.34),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SoftCutPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _SteamLinePainter extends CustomPainter {
  static const Color _lineColor = Color(0x44C9922A);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.18)
      ..cubicTo(
        size.width * 0.32,
        size.height * 0.05,
        size.width * 0.55,
        size.height * 0.34,
        size.width * 0.82,
        size.height * 0.17,
      );

    final secondPath = Path()
      ..moveTo(size.width * 0.08, size.height * 0.78)
      ..cubicTo(
        size.width * 0.38,
        size.height * 0.64,
        size.width * 0.61,
        size.height * 0.92,
        size.width * 0.94,
        size.height * 0.74,
      );

    canvas
      ..drawPath(path, paint)
      ..drawPath(secondPath, paint..color = _lineColor.withValues(alpha: 0.18));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
