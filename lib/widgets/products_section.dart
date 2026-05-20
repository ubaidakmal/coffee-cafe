import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'product_hover_card.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({
    required this.progress,
    required this.isWide,
    required this.creamImageOpacity,
    super.key,
  });

  final double progress;
  final bool isWide;
  final double creamImageOpacity;

  static const Color _deepBrown = Color(0xFF2A1005);
  static const Color _gold = Color(0xFFC9922A);
  static const Color _cream = Color(0xFFF5E6CC);
  static const Color _softCream = Color(0xFFF9EFD9);
  static const Color _mutedBrown = Color(0xFF6B4A2A);

  static const List<_ProductData> _products = [
    _ProductData(
      title: 'Burgundy Signature Cup',
      description: 'Bold espresso character with a rich premium look.',
      price: 'From 18 SAR',
      normalSrc: 'assets/images/coffeePaperCup1.jpg',
      revealSrc: 'assets/images/coffeePaperCup1Reveal.jpg',
      alt: 'Burgundy Koffiqa cup',
    ),
    _ProductData(
      title: 'Cream Classic Cup',
      description:
          'Smooth, elegant, and crafted for everyday specialty coffee.',
      price: 'From 16 SAR',
      normalSrc: 'assets/images/coffeePaperCup2.jpg',
      revealSrc: 'assets/images/coffeePaperCup2Reveal.jpg',
      alt: 'Cream Koffiqa cup',
      isCream: true,
    ),
    _ProductData(
      title: 'Dark Roast Cup',
      description: 'Deep roasted mood with a luxurious dark finish.',
      price: 'From 20 SAR',
      normalSrc: 'assets/images/coffeePaperCup3.jpg',
      revealSrc: 'assets/images/coffeePaperCup3Reveal.jpg',
      alt: 'Dark roast Koffiqa cup',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = isWide ? 0.0 : 4.0;
    final headingSize = width < 420
        ? 38.0
        : width < 760
        ? 46.0
        : 58.0;
    final headerProgress = isWide ? _interval(progress, 0.05, 0.44) : 1.0;
    final cardsProgress = isWide ? _interval(progress, 0.24, 0.92) : 1.0;

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
            right: isWide ? -110 : -150,
            top: isWide ? 90 : 160,
            child: _RadialGlow(size: isWide ? 560 : 360, opacity: 0.16),
          ),
          Positioned(
            left: isWide ? -140 : -190,
            bottom: isWide ? -160 : -110,
            child: _RadialGlow(size: isWide ? 500 : 320, opacity: 0.09),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              isWide ? 58 : 68,
              horizontalPadding,
              isWide ? 44 : 54,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _AnimatedBlock(
                  progress: headerProgress,
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 30,
                            height: 2,
                            decoration: BoxDecoration(
                              color: _gold,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'OUR PRODUCTS',
                            style: GoogleFonts.poppins(
                              color: _gold,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Text(
                          'Signature cups for every coffee mood.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: _deepBrown,
                            fontSize: headingSize,
                            height: 1.04,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 690),
                        child: Text(
                          'Explore Koffiqa\'s premium cup collection, crafted '
                          'for specialty coffee lovers who enjoy bold taste, '
                          'warm design, and a memorable cafe experience.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: _mutedBrown,
                            fontSize: 16,
                            height: 1.58,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isWide ? 42 : 28),
                _ProductGrid(
                  products: _products,
                  isWide: isWide,
                  progress: cardsProgress,
                  creamImageOpacity: isWide ? creamImageOpacity : 1,
                ),
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

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({
    required this.products,
    required this.isWide,
    required this.progress,
    required this.creamImageOpacity,
  });

  final List<_ProductData> products;
  final bool isWide;
  final double progress;
  final double creamImageOpacity;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final imageSize = isWide
        ? ((width - 220) / 3 * 0.66).clamp(220.0, 290.0)
        : width < 420
        ? 245.0
        : 285.0;

    if (!isWide) {
      return Column(
        children: [
          for (final entry in products.indexed) ...[
            _AnimatedBlock(
              progress: ProductsSection._interval(progress, entry.$1 * 0.1, 1),
              child: ProductHoverCard(
                title: entry.$2.title,
                description: entry.$2.description,
                price: entry.$2.price,
                normalSrc: entry.$2.normalSrc,
                revealSrc: entry.$2.revealSrc,
                imageAlt: entry.$2.alt,
                imageSize: imageSize,
                imageOpacity: 1,
                isFeatured: entry.$2.isCream,
              ),
            ),
            if (entry.$1 < products.length - 1) const SizedBox(height: 24),
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in products.indexed) ...[
          Expanded(
            child: _AnimatedBlock(
              progress: ProductsSection._interval(progress, entry.$1 * 0.11, 1),
              child: ProductHoverCard(
                title: entry.$2.title,
                description: entry.$2.description,
                price: entry.$2.price,
                normalSrc: entry.$2.normalSrc,
                revealSrc: entry.$2.revealSrc,
                imageAlt: entry.$2.alt,
                imageSize: imageSize,
                imageOpacity: entry.$2.isCream ? creamImageOpacity : 1,
                isFeatured: entry.$2.isCream,
              ),
            ),
          ),
          if (entry.$1 < products.length - 1) const SizedBox(width: 24),
        ],
      ],
    );
  }
}

class _AnimatedBlock extends StatelessWidget {
  const _AnimatedBlock({required this.progress, required this.child});

  final double progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, lerpDouble(50, 0, progress)!),
      child: Opacity(opacity: progress, child: child),
    );
  }
}

class _RadialGlow extends StatelessWidget {
  const _RadialGlow({required this.size, required this.opacity});

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
            ProductsSection._gold.withValues(alpha: opacity),
            ProductsSection._gold.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class _ProductData {
  const _ProductData({
    required this.title,
    required this.description,
    required this.price,
    required this.normalSrc,
    required this.revealSrc,
    required this.alt,
    this.isCream = false,
  });

  final String title;
  final String description;
  final String price;
  final String normalSrc;
  final String revealSrc;
  final String alt;
  final bool isCream;
}
