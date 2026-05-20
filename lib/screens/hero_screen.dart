import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/bean_rain_animation.dart';
import '../widgets/big_bean_pop.dart';
import '../widgets/organic_door_reveal.dart';
import 'reveal_screen.dart';

class HeroScreen extends StatefulWidget {
  const HeroScreen({super.key});

  @override
  State<HeroScreen> createState() => _HeroScreenState();
}

class _HeroScreenState extends State<HeroScreen> {
  Timer? _doorTimer;
  bool _rainCompleted = false;
  bool _doorOpening = false;
  bool _showHeroOverlay = true;

  static const Color _espresso = Color(0xFF120600);

  void _handleRainCompleted() {
    if (_rainCompleted || !mounted) {
      return;
    }

    setState(() {
      _rainCompleted = true;
    });

    _doorTimer = Timer(const Duration(milliseconds: 1300), () {
      if (mounted && !_doorOpening) {
        _startDoorReveal();
      }
    });
  }

  void _startDoorReveal() {
    if (_doorOpening || !mounted) {
      return;
    }

    _doorTimer?.cancel();
    setState(() {
      _rainCompleted = true;
      _doorOpening = true;
    });
  }

  void _handleDoorCompleted() {
    if (!mounted) {
      return;
    }

    setState(() {
      _showHeroOverlay = false;
    });
  }

  @override
  void dispose() {
    _doorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final beanWidth = (size.shortestSide * 0.52).clamp(165.0, 260.0);

    return Scaffold(
      backgroundColor: _espresso,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_doorOpening || !_showHeroOverlay)
            const RevealScreen(initialDelay: 240)
          else
            const ColoredBox(color: _espresso),
          if (_showHeroOverlay)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _startDoorReveal,
              child: _doorOpening
                  ? OrganicDoorReveal(
                      open: true,
                      onCompleted: _handleDoorCompleted,
                      child: _HeroIntroContent(
                        beanWidth: beanWidth,
                        rainSettled: true,
                        showBigBean: true,
                      ),
                    )
                  : _HeroIntroContent(
                      beanWidth: beanWidth,
                      rainSettled: false,
                      showBigBean: _rainCompleted,
                      onRainCompleted: _handleRainCompleted,
                    ),
            ),
        ],
      ),
    );
  }
}

class _HeroIntroContent extends StatelessWidget {
  const _HeroIntroContent({
    required this.beanWidth,
    required this.rainSettled,
    required this.showBigBean,
    this.onRainCompleted,
  });

  final double beanWidth;
  final bool rainSettled;
  final bool showBigBean;
  final VoidCallback? onRainCompleted;

  static const Color _espresso = Color(0xFF120600);
  static const Color _deepBrown = Color(0xFF2A1005);
  static const Color _cream = Color(0xFFF5E6CC);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return RepaintBoundary(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.08),
            radius: 1.08,
            colors: [Color(0xFF3A1708), _deepBrown, _espresso],
            stops: [0.0, 0.44, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _SteamLinePainter()),
              Positioned(
                top: size.height * 0.1,
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
                  groundYFactor: 0.64,
                  duration: const Duration(milliseconds: 3900),
                  settled: rainSettled,
                  onCompleted: rainSettled ? null : onRainCompleted,
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.08),
                child: BigBeanPop(visible: showBigBean, size: beanWidth),
              ),
            ],
          ),
        ),
      ),
    );
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
