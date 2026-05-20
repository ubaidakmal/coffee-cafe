import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/bean_rain_animation.dart';
import '../widgets/split_bean.dart';
import 'reveal_screen.dart';

class HeroScreen extends StatefulWidget {
  const HeroScreen({super.key});

  @override
  State<HeroScreen> createState() => _HeroScreenState();
}

class _HeroScreenState extends State<HeroScreen> with TickerProviderStateMixin {
  late final AnimationController _idleController;
  late final AnimationController _splitController;
  Timer? _introTimer;
  bool _rainCompleted = false;
  bool _splitStarted = false;
  bool _showIntroOverlay = true;

  static const Color _espresso = Color(0xFF180800);

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
    _splitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..addStatusListener(_handleAnimationStatus);
  }

  void _handleRainCompleted() {
    if (_rainCompleted || !mounted) {
      return;
    }

    setState(() {
      _rainCompleted = true;
    });
    _introTimer = Timer(const Duration(milliseconds: 1350), () {
      if (mounted && !_splitStarted) {
        _startSplit();
      }
    });
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _showIntroOverlay && mounted) {
      _idleController.stop();
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
    _idleController.stop();
    setState(() {
      _rainCompleted = true;
      _splitStarted = true;
    });
    _splitController.forward();
  }

  @override
  void dispose() {
    _introTimer?.cancel();
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
                idleController: _idleController,
                beanWidth: beanWidth,
                rainCompleted: _rainCompleted,
                onRainCompleted: _handleRainCompleted,
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
    required this.idleController,
    required this.beanWidth,
    required this.rainCompleted,
    required this.onRainCompleted,
  });

  final AnimationController splitController;
  final AnimationController idleController;
  final double beanWidth;
  final bool rainCompleted;
  final VoidCallback onRainCompleted;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final scene = _IntroScene(
          splitController: splitController,
          idleController: idleController,
          beanWidth: beanWidth,
          rainCompleted: rainCompleted,
          onRainCompleted: onRainCompleted,
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
    required this.idleController,
    required this.beanWidth,
    required this.rainCompleted,
    required this.onRainCompleted,
  });

  final AnimationController splitController;
  final AnimationController idleController;
  final double beanWidth;
  final bool rainCompleted;
  final VoidCallback onRainCompleted;

  static const Color _espresso = Color(0xFF180800);
  static const Color _deepBrown = Color(0xFF2A1005);
  static const Color _cream = Color(0xFFF5E6CC);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

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
                Positioned(
                  top: size.height * 0.11,
                  left: 24,
                  right: 24,
                  child: Text(
                    'KOFFIQA',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: _cream,
                      fontSize: (size.width * 0.13).clamp(44.0, 76.0),
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                IgnorePointer(
                  child: BeanRainAnimation(
                    beanCount: 44,
                    groundYFactor: 0.58,
                    duration: const Duration(milliseconds: 3200),
                    onCompleted: onRainCompleted,
                  ),
                ),
                Center(
                  child: _BeanIntroStage(
                    splitController: splitController,
                    idleController: idleController,
                    beanWidth: beanWidth,
                    rainCompleted: rainCompleted,
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
    required this.idleController,
    required this.beanWidth,
    required this.rainCompleted,
  });

  final AnimationController splitController;
  final AnimationController idleController;
  final double beanWidth;
  final bool rainCompleted;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final stageSize = (screen.shortestSide * 0.82).clamp(300.0, 470.0);

    return SizedBox(
      width: stageSize,
      height: stageSize * 1.18,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: rainCompleted ? 1 : 0),
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeOutBack,
        builder: (context, revealProgress, child) {
          return AnimatedBuilder(
            animation: Listenable.merge([idleController, splitController]),
            builder: (context, child) {
              final bigReveal = revealProgress.clamp(0.0, 1.0);
              final splitValue = splitController.value;
              final idle = math.sin(idleController.value * math.pi * 2);
              final bigScale = bigReveal * (1 + idle * 0.018);
              final bigLift = idle * 5 * bigReveal * (1 - splitValue);
              final beanOpacity = (bigReveal * (1 - splitValue * 0.08)).clamp(
                0.0,
                1.0,
              );

              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
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
                            SplitBean(
                              controller: splitController,
                              size: beanWidth,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
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
