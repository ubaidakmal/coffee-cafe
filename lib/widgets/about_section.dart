import 'dart:ui' show ImageFilter, lerpDouble;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    required this.progress,
    required this.isWide,
    required this.showStaticCup,
    super.key,
  });

  final double progress;
  final bool isWide;
  final bool showStaticCup;

  static const Color _espresso = Color(0xFF180800);
  static const Color _deepBrown = Color(0xFF2A1005);
  static const Color _gold = Color(0xFFC9922A);
  static const Color _cream = Color(0xFFF5E6CC);
  static const Color _softCream = Color(0xFFF9EFD9);
  static const Color _mutedBrown = Color(0xFF6B4A2A);

  static const String _creamCup = 'assets/images/coffeePaperCup2.jpg';
  static const String _coffeeBeans = 'assets/images/coffeeBeans.jpg';

  @override
  Widget build(BuildContext context) {
    final copyProgress = isWide ? _interval(progress, 0.22, 0.92) : 1.0;
    final beansProgress = isWide ? _interval(progress, 0.08, 0.82) : 1.0;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_cream, _softCream],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: isWide ? 100 : -44,
            bottom: isWide ? 10 : 430,
            child: _CoffeeBeansDecor(
              progress: beansProgress,
              size: isWide ? 520 : 330,
            ),
          ),
          if (isWide)
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: showStaticCup
                      ? const Center(child: _StaticCreamCup())
                      : const SizedBox.expand(),
                ),
                const SizedBox(width: 46),
                Expanded(
                  flex: 9,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _AboutCopy(progress: copyProgress),
                  ),
                ),
              ],
            )
          else
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Center(child: _StaticCreamCup(size: 330)),
                  const SizedBox(height: 22),
                  _AboutCopy(progress: copyProgress),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static double _interval(double value, double start, double end) {
    final normalized = ((value - start) / (end - start)).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(normalized);
  }
}

class _StaticCreamCup extends StatelessWidget {
  const _StaticCreamCup({this.size = 430});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.045,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.08),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C270F).withValues(alpha: 0.28),
              blurRadius: size * 0.13,
              offset: Offset(0, size * 0.09),
            ),
          ],
        ),
        child: Image.asset(
          AboutSection._creamCup,
          width: size,
          height: size * 1.14,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class _CoffeeBeansDecor extends StatelessWidget {
  const _CoffeeBeansDecor({required this.progress, required this.size});

  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    final opacity = lerpDouble(0.05, 1, progress)!;
    final y = lerpDouble(46, -12, progress)!;

    return Transform.translate(
      offset: Offset(0, y),
      child: Opacity(
        opacity: opacity,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 0.55, sigmaY: 0.55),
          child: Container(
            width: size,
            height: size * 0.64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A220C).withValues(alpha: 0.24),
                  blurRadius: 100,
                  offset: const Offset(0, 30),
                ),
              ],
              image: const DecorationImage(
                image: AssetImage(AboutSection._coffeeBeans),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutCopy extends StatelessWidget {
  const _AboutCopy({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final headingSize = width < 420
        ? 38.0
        : width < 760
        ? 46.0
        : 58.0;

    return Transform.translate(
      offset: Offset(0, lerpDouble(34, 0, progress)!),
      child: Opacity(
        opacity: progress,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AnimatedLine(
                progress: _interval(0.0, 0.34),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30,
                      height: 2,
                      decoration: BoxDecoration(
                        color: AboutSection._gold,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'ABOUT KOFFIQA',
                      style: GoogleFonts.poppins(
                        color: AboutSection._gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _AnimatedLine(
                progress: _interval(0.12, 0.48),
                child: Text(
                  'Crafted for people who take coffee seriously.',
                  style: GoogleFonts.poppins(
                    color: AboutSection._deepBrown,
                    fontSize: headingSize,
                    height: 1.04,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              _AnimatedLine(
                progress: _interval(0.24, 0.6),
                child: Text(
                  'Koffiqa brings together specialty roasting, warm Saudi cafe '
                  'culture, and carefully crafted drinks. From espresso blends '
                  'to smooth iced favorites, every cup is designed to feel rich, '
                  'aromatic, and memorable.',
                  style: GoogleFonts.poppins(
                    color: AboutSection._mutedBrown,
                    fontSize: 16,
                    height: 1.62,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _FeaturePill(
                    text: 'Specialty coffee roasted with care',
                    progress: _interval(0.32, 0.68),
                  ),
                  _FeaturePill(
                    text: 'Premium cafe experience in Al Khobar',
                    progress: _interval(0.42, 0.78),
                  ),
                  _FeaturePill(
                    text: 'Signature hot and iced drinks',
                    progress: _interval(0.52, 0.88),
                  ),
                  _FeaturePill(
                    text: 'Crafted with warm Saudi hospitality',
                    progress: _interval(0.62, 1),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _AnimatedLine(
                progress: _interval(0.68, 1),
                child: _StoryButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _interval(double start, double end) {
    final normalized = ((progress - start) / (end - start)).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(normalized);
  }
}

class _AnimatedLine extends StatelessWidget {
  const _AnimatedLine({required this.progress, required this.child});

  final double progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, lerpDouble(24, 0, progress)!),
      child: Opacity(opacity: progress, child: child),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.text, required this.progress});

  final String text;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return _AnimatedLine(
      progress: progress,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.38),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AboutSection._gold.withValues(alpha: 0.18)),
          boxShadow: [
            BoxShadow(
              color: AboutSection._espresso.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_cafe_rounded,
              color: AboutSection._gold,
              size: 17,
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: AboutSection._deepBrown,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AboutSection._deepBrown,
      borderRadius: BorderRadius.circular(8),
      elevation: 12,
      shadowColor: AboutSection._deepBrown.withValues(alpha: 0.18),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          child: Text(
            'Discover Our Story',
            style: GoogleFonts.poppins(
              color: AboutSection._cream,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
