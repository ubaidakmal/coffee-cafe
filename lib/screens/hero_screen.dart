import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/split_bean.dart';
import 'reveal_screen.dart';

class HeroScreen extends StatefulWidget {
  const HeroScreen({super.key});

  @override
  State<HeroScreen> createState() => _HeroScreenState();
}

class _HeroScreenState extends State<HeroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _splitController;
  Timer? _introTimer;
  bool _hasStarted = false;
  bool _showIntroOverlay = true;

  static const Color _espresso = Color(0xFF180800);

  @override
  void initState() {
    super.initState();
    _splitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..addStatusListener(_handleAnimationStatus);

    _introTimer = Timer(const Duration(seconds: 2), _startSplit);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _showIntroOverlay && mounted) {
      setState(() {
        _showIntroOverlay = false;
      });
    }
  }

  void _startSplit() {
    if (_hasStarted || !mounted) {
      return;
    }

    _introTimer?.cancel();
    setState(() {
      _hasStarted = true;
    });
    _splitController.forward();
  }

  @override
  void dispose() {
    _introTimer?.cancel();
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
          if (_hasStarted)
            const RevealScreen(initialDelay: 520)
          else
            const ColoredBox(color: _espresso),
          if (_showIntroOverlay)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _startSplit,
              child: _SplitIntroOverlay(
                controller: _splitController,
                beanWidth: beanWidth,
              ),
            ),
        ],
      ),
    );
  }
}

class _SplitIntroOverlay extends StatelessWidget {
  const _SplitIntroOverlay({required this.controller, required this.beanWidth});

  final AnimationController controller;
  final double beanWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final scene = _IntroScene(controller: controller, beanWidth: beanWidth);

        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final progress = controller.value;
            final curved = Curves.easeInOutCubicEmphasized.transform(progress);
            final travel = width * 0.6 * curved;
            final crustOpacity = math.sin(progress * math.pi).clamp(0.0, 1.0);

            return Stack(
              fit: StackFit.expand,
              children: [
                Transform.translate(
                  offset: Offset(-travel, 0),
                  child: _IntroHalf(
                    alignment: Alignment.centerLeft,
                    width: width,
                    height: height,
                    child: scene,
                  ),
                ),
                Transform.translate(
                  offset: Offset(travel, 0),
                  child: _IntroHalf(
                    alignment: Alignment.centerRight,
                    width: width,
                    height: height,
                    child: scene,
                  ),
                ),
                IgnorePointer(
                  child: Opacity(
                    opacity: crustOpacity,
                    child: CustomPaint(
                      painter: _CutCrustPainter(progress: curved),
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
  const _IntroScene({required this.controller, required this.beanWidth});

  final AnimationController controller;
  final double beanWidth;

  static const Color _espresso = Color(0xFF180800);
  static const Color _deepBrown = Color(0xFF2A1005);
  static const Color _gold = Color(0xFFC9922A);
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 26,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'EST. \u00B7 AL KHOBAR, KSA \u00B7 AJDAN WALK',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: _cream.withValues(alpha: 0.7),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const Spacer(flex: 2),
                        Text(
                          'KOFFIQA',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: _cream,
                            fontSize: (size.width * 0.15).clamp(44.0, 76.0),
                            fontWeight: FontWeight.w800,
                            height: 0.98,
                            letterSpacing: 2.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'CAF\u00C9 & ROASTERY',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: _gold,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                          ),
                        ),
                        const Spacer(),
                        SplitBean(controller: controller, size: beanWidth),
                        const Spacer(flex: 2),
                        AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return Opacity(
                              opacity: 1 - controller.value,
                              child: child,
                            );
                          },
                          child: Text(
                            'TAP TO REVEAL',
                            style: GoogleFonts.poppins(
                              color: _cream.withValues(alpha: 0.45),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
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

class _CutCrustPainter extends CustomPainter {
  const _CutCrustPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final gap = size.width * 0.6 * progress;
    final leftEdge = centerX - gap;
    final rightEdge = centerX + gap;
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.2
      ..color = const Color(0xFFC9922A).withValues(alpha: 0.72)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.4);
    final emberPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFF5E6CC).withValues(alpha: 0.72)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.6);
    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7
      ..color = const Color(0xFF2A1005).withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9);

    void drawEdge(double x, double direction) {
      final shadowPath = Path()..moveTo(x, -10);
      final crustPath = Path()..moveTo(x, -10);

      for (var i = 0; i <= 18; i++) {
        final y = size.height * i / 18;
        final wave =
            math.sin(i * 1.7 + progress * 5) * 7 +
            math.cos(i * 0.9 + progress * 8) * 4;
        final crustX = x + wave * direction;
        shadowPath.lineTo(crustX, y);
        crustPath.lineTo(crustX, y);
      }

      canvas
        ..drawPath(shadowPath, shadowPaint)
        ..drawPath(crustPath, edgePaint);
    }

    drawEdge(leftEdge, -1);
    drawEdge(rightEdge, 1);

    for (var i = 0; i < 34; i++) {
      final t = i / 33;
      final y = size.height * (0.12 + 0.78 * t);
      final drift = math.sin(i * 2.31) * gap * 0.11;
      final side = i.isEven ? -1.0 : 1.0;
      final x = centerX + side * gap * (0.14 + 0.28 * ((i % 7) / 7)) + drift;
      final radius = 1.2 + (i % 5) * 0.42;

      canvas.drawCircle(
        Offset(x, y + math.cos(i * 1.43) * 16),
        radius,
        emberPaint
          ..color =
              (i % 3 == 0 ? const Color(0xFFC9922A) : const Color(0xFFF5E6CC))
                  .withValues(alpha: 0.62),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CutCrustPainter oldDelegate) {
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
