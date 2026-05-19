import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/flying_cup.dart';

class RevealScreen extends StatelessWidget {
  const RevealScreen({this.initialDelay = 0, super.key});

  final int initialDelay;

  static const Color _espresso = Color(0xFF180800);
  static const Color _deepBrown = Color(0xFF2A1005);
  static const Color _gold = Color(0xFFC9922A);
  static const Color _cream = Color(0xFFF5E6CC);
  static const Color _mutedBrown = Color(0xFF6B4A2A);

  static const String _redCup = 'assets/images/coffeePaperCup1.jpg';
  static const String _creamCup = 'assets/images/coffeePaperCup2.jpg';
  static const String _darkCup = 'assets/images/coffeePaperCup3.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: _RevealAppBar(initialDelay: initialDelay),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 760;
            final horizontalPadding = (constraints.maxWidth * 0.08).clamp(
              24.0,
              86.0,
            );

            if (isWide) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: _CopyBlock(
                        maxHeadlineWidth: constraints.maxWidth * 0.42,
                        initialDelay: initialDelay,
                      ),
                    ),
                    const SizedBox(width: 28),
                    Expanded(
                      flex: 8,
                      child: _CupStage(
                        isWide: true,
                        initialDelay: initialDelay,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  18,
                  horizontalPadding,
                  28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CupStage(isWide: false, initialDelay: initialDelay),
                    const SizedBox(height: 18),
                    _CopyBlock(
                      maxHeadlineWidth: double.infinity,
                      initialDelay: initialDelay,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RevealAppBar extends StatelessWidget {
  const _RevealAppBar({required this.initialDelay});

  final int initialDelay;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 680;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isWide ? 54 : 22),
        child: SizedBox(
          height: 74,
          child: Row(
            children: [
              Text(
                    'KOFFIQA',
                    style: GoogleFonts.poppins(
                      color: RevealScreen._espresso,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  )
                  .animate(delay: (initialDelay + 120).ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: -0.35, end: 0, duration: 640.ms),
              if (isWide) ...[
                const Spacer(),
                _NavText('Menu', delay: initialDelay + 220),
                _NavText('Roastery', delay: initialDelay + 310),
                _NavText('Ajdan Walk', delay: initialDelay + 400),
                const SizedBox(width: 24),
              ] else
                const Spacer(),
              Material(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: RevealScreen._deepBrown.withValues(alpha: 0.22),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Icon(
                          isWide ? Icons.arrow_forward : Icons.menu,
                          color: RevealScreen._deepBrown,
                          size: 18,
                        ),
                      ),
                    ),
                  )
                  .animate(delay: (initialDelay + 500).ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: -0.28, end: 0, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavText extends StatelessWidget {
  const _NavText(this.label, {required this.delay});

  final String label;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child:
          Text(
                label,
                style: GoogleFonts.poppins(
                  color: RevealScreen._mutedBrown,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              )
              .animate(delay: delay.ms)
              .fadeIn(duration: 420.ms)
              .slideY(begin: -0.25, end: 0, duration: 560.ms),
    );
  }
}

class _CopyBlock extends StatelessWidget {
  const _CopyBlock({
    required this.maxHeadlineWidth,
    required this.initialDelay,
  });

  final double maxHeadlineWidth;
  final int initialDelay;

  static const Color _espresso = RevealScreen._espresso;
  static const Color _gold = RevealScreen._gold;
  static const Color _mutedBrown = RevealScreen._mutedBrown;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final headlineSize = width < 420
        ? 43.0
        : width < 760
        ? 52.0
        : 64.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, color: _gold, size: 9),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'SPECIALTY COFFEE \u00B7 AL KHOBAR',
                    style: GoogleFonts.poppins(
                      color: _mutedBrown,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            )
            .animate(delay: initialDelay.ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.3, end: 0, duration: 650.ms),
        const SizedBox(height: 20),
        ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxHeadlineWidth),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    color: _espresso,
                    fontSize: headlineSize,
                    fontWeight: FontWeight.w800,
                    height: 1.04,
                  ),
                  children: const [
                    TextSpan(text: 'Rich & '),
                    TextSpan(
                      text: 'Aromatic',
                      style: TextStyle(color: _gold),
                    ),
                    TextSpan(text: '\nLounge Coffee'),
                  ],
                ),
              ),
            )
            .animate(delay: (initialDelay + 150).ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.24, end: 0, duration: 760.ms),
        const SizedBox(height: 24),
        ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Text(
                'From carefully sourced single-origin beans to expertly crafted '
                'espresso blends, every cup is a story of passion.',
                style: GoogleFonts.poppins(
                  color: _mutedBrown,
                  fontSize: 16,
                  height: 1.55,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
            .animate(delay: (initialDelay + 300).ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, end: 0, duration: 720.ms),
        const SizedBox(height: 30),
        _ShopButton()
            .animate(delay: (initialDelay + 450).ms)
            .fadeIn(duration: 560.ms)
            .slideY(begin: 0.18, end: 0, duration: 680.ms),
        const SizedBox(height: 36),
        Wrap(
              spacing: 30,
              runSpacing: 18,
              children: const [
                _Stat(value: '20+', label: 'FLAVOURS'),
                _Stat(value: '15K+', label: 'REVIEWS'),
                _Stat(value: '4.6\u2605', label: 'RATING'),
              ],
            )
            .animate(delay: (initialDelay + 600).ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.16, end: 0, duration: 700.ms),
      ],
    );
  }
}

class _ShopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: RevealScreen._deepBrown,
      borderRadius: BorderRadius.circular(8),
      elevation: 14,
      shadowColor: RevealScreen._deepBrown.withValues(alpha: 0.28),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            'SHOP NOW \u2192',
            style: GoogleFonts.poppins(
              color: RevealScreen._cream,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 94,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              color: RevealScreen._espresso,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: RevealScreen._mutedBrown,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CupStage extends StatelessWidget {
  const _CupStage({required this.isWide, required this.initialDelay});

  final bool isWide;
  final int initialDelay;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final stageHeight = isWide ? 620.0 : (width * 0.94).clamp(330.0, 470.0);
    final mainCup = isWide ? 310.0 : (width * 0.46).clamp(170.0, 230.0);
    final supportingCup = isWide ? 230.0 : (width * 0.34).clamp(120.0, 170.0);
    final smallCup = isWide ? 205.0 : (width * 0.3).clamp(105.0, 150.0);

    return SizedBox(
      height: stageHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: isWide ? 34 : -22,
            top: isWide ? 118 : 54,
            child: _SoftCircle(size: isWide ? 430 : 280),
          ),
          Positioned(
            right: isWide ? 20 : -18,
            bottom: isWide ? 42 : 24,
            child: _SoftCircle(size: isWide ? 250 : 160, opacity: 0.18),
          ),
          FlyingCup(
            imagePath: RevealScreen._creamCup,
            size: supportingCup,
            top: isWide ? 92 : 28,
            right: isWide ? 150 : 116,
            rotation: -0.12,
            delay: initialDelay + 220,
          ),
          FlyingCup(
            imagePath: RevealScreen._darkCup,
            size: mainCup,
            top: isWide ? 172 : 96,
            right: isWide ? 24 : 24,
            rotation: 0.08,
            delay: initialDelay + 620,
          ),
          FlyingCup(
            imagePath: RevealScreen._redCup,
            size: smallCup,
            bottom: isWide ? 92 : 38,
            right: isWide ? 242 : 170,
            rotation: -0.19,
            delay: initialDelay + 1020,
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, this.opacity = 0.28});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            RevealScreen._gold.withValues(alpha: opacity),
            RevealScreen._gold.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
