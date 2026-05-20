import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'hover_reveal_cup.dart';

class ProductHoverCard extends StatefulWidget {
  const ProductHoverCard({
    required this.title,
    required this.description,
    required this.price,
    required this.normalSrc,
    required this.revealSrc,
    required this.imageAlt,
    required this.imageSize,
    this.imageOpacity = 1,
    this.isFeatured = false,
    super.key,
  });

  final String title;
  final String description;
  final String price;
  final String normalSrc;
  final String revealSrc;
  final String imageAlt;
  final double imageSize;
  final double imageOpacity;
  final bool isFeatured;

  static const Color _espresso = Color(0xFF180800);
  static const Color _deepBrown = Color(0xFF2A1005);
  static const Color _gold = Color(0xFFC9922A);
  static const Color _cream = Color(0xFFF5E6CC);
  static const Color _mutedBrown = Color(0xFF6B4A2A);

  @override
  State<ProductHoverCard> createState() => _ProductHoverCardState();
}

class _ProductHoverCardState extends State<ProductHoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: widget.imageSize * 1.32,
            width: double.infinity,
            child: Center(
              child: AnimatedOpacity(
                opacity: widget.imageOpacity,
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                child: HoverRevealCup(
                  normalSrc: widget.normalSrc,
                  revealSrc: widget.revealSrc,
                  semanticLabel: widget.imageAlt,
                  size: widget.imageSize,
                  revealScale: 1.09,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            widget.title,
            style: GoogleFonts.poppins(
              color: ProductHoverCard._deepBrown,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.description,
            style: GoogleFonts.poppins(
              color: ProductHoverCard._mutedBrown,
              fontSize: 13.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.price,
                  style: GoogleFonts.poppins(
                    color: ProductHoverCard._espresso,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Material(
                color: ProductHoverCard._deepBrown,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    child: Text(
                      'Order',
                      style: GoogleFonts.poppins(
                        color: ProductHoverCard._cream,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.025 : 1,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        child: AnimatedSlide(
          offset: Offset(0, _hovered ? -0.018 : 0),
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: widget.isFeatured ? 0.44 : 0.34,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: ProductHoverCard._gold.withValues(alpha: 0.22),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A220C).withValues(alpha: 0.14),
                  blurRadius: 70,
                  offset: const Offset(0, 28),
                ),
              ],
            ),
            child: cardContent,
          ),
        ),
      ),
    );
  }
}
