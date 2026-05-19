import 'dart:ui';

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
        preferredSize: const Size.fromHeight(94),
        child: _RevealAppBar(initialDelay: initialDelay),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide =
                constraints.maxWidth >= 760 && constraints.maxHeight >= 620;
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
      child: SizedBox(
        height: 94,
        child: Center(
          child:
              ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.34),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: RevealScreen._deepBrown.withValues(
                                alpha: 0.12,
                              ),
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isWide ? 24 : 18,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'KOFFIQA',
                                style: GoogleFonts.poppins(
                                  color: RevealScreen._espresso,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.8,
                                ),
                              ),
                              if (isWide) ...[
                                const SizedBox(width: 26),
                                const _GlassNavText('Menu'),
                                const _GlassDivider(),
                                const _GlassNavText('Roastery'),
                                const _GlassDivider(),
                                const _GlassNavText('Ajdan Walk'),
                              ] else ...[
                                const SizedBox(width: 18),
                                Icon(
                                  Icons.menu_rounded,
                                  color: RevealScreen._deepBrown,
                                  size: 20,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .animate(delay: (initialDelay + 220).ms)
                  .fadeIn(duration: 520.ms)
                  .slideY(begin: -0.45, end: 0, duration: 760.ms)
                  .scale(
                    begin: const Offset(0.96, 0.96),
                    end: const Offset(1, 1),
                    duration: 760.ms,
                    curve: Curves.easeOutCubic,
                  ),
        ),
      ),
    );
  }
}

class _GlassNavText extends StatelessWidget {
  const _GlassNavText(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        color: RevealScreen._mutedBrown,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _GlassDivider extends StatelessWidget {
  const _GlassDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 18,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      color: RevealScreen._mutedBrown.withValues(alpha: 0.18),
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
    final stageHeight = isWide ? 1000.0 : (width * 1.1).clamp(430.0, 610.0);
    final mainCup = isWide ? 750.0 : (width * 0.74).clamp(270.0, 390.0);
    final supportingCup = isWide ? 600.0 : (width * 0.55).clamp(205.0, 295.0);
    final smallCup = isWide ? 600.0 : (width * 0.5).clamp(185.0, 270.0);

    return SizedBox(
      height: stageHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: isWide ? -18 : -58,
            top: isWide ? 106 : 74,
            child: _SoftCircle(size: isWide ? 560 : 390),
          ),
          Positioned(
            right: isWide ? -42 : -54,
            bottom: isWide ? 34 : 34,
            child: _SoftCircle(size: isWide ? 360 : 230, opacity: 0.18),
          ),
          FlyingCup(
            imagePath: RevealScreen._creamCup,
            size: supportingCup,
            top: isWide ? 10 : 18,
            right: isWide ? 310 : 148,
            rotation: 0,
            delay: initialDelay + 220,
          ),
          FlyingCup(
            imagePath: RevealScreen._darkCup,
            size: mainCup,
            top: isWide ? 148 : 116,
            right: isWide ? -140 : -30,
            rotation: 0.3,
            delay: initialDelay + 620,
          ),
          FlyingCup(
            imagePath: RevealScreen._redCup,
            size: smallCup,
            bottom: isWide ? 10 : 34,
            right: isWide ? 700 : 210,
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
