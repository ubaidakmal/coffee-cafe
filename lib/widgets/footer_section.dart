import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  static const Color _espresso = Color(0xFF180800);
  static const Color _deepBrown = Color(0xFF2A1005);
  static const Color _gold = Color(0xFFC9922A);
  static const Color _cream = Color(0xFFF5E6CC);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 760;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_deepBrown, _espresso],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 34 : 22,
          vertical: isWide ? 42 : 34,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex: 5, child: _FooterBrand()),
                      const SizedBox(width: 42),
                      Expanded(
                        child: _FooterColumn(
                          title: 'Explore',
                          items: const [
                            'Home',
                            'About Us',
                            'Our Products',
                            'Contact Us',
                          ],
                        ),
                      ),
                      const SizedBox(width: 28),
                      Expanded(
                        child: _FooterColumn(
                          title: 'Cafe',
                          items: const [
                            'Ajdan Walk',
                            'Al Khobar',
                            'Specialty Coffee',
                            'Roastery',
                          ],
                        ),
                      ),
                    ],
                  )
                : const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FooterBrand(),
                      SizedBox(height: 28),
                      _FooterColumn(
                        title: 'Explore',
                        items: [
                          'Home',
                          'About Us',
                          'Our Products',
                          'Contact Us',
                        ],
                      ),
                      SizedBox(height: 22),
                      _FooterColumn(
                        title: 'Cafe',
                        items: [
                          'Ajdan Walk',
                          'Al Khobar',
                          'Specialty Coffee',
                          'Roastery',
                        ],
                      ),
                    ],
                  ),
            const SizedBox(height: 34),
            Container(height: 1, color: _cream.withValues(alpha: 0.12)),
            const SizedBox(height: 18),
            Text(
              '© 2026 KOFFIQA. Crafted for a premium Saudi coffee experience.',
              textAlign: isWide ? TextAlign.left : TextAlign.center,
              style: GoogleFonts.poppins(
                color: _cream.withValues(alpha: 0.62),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: FooterSection._gold,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'KOFFIQA',
              style: GoogleFonts.poppins(
                color: FooterSection._cream,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            'Specialty coffee, premium cups, and warm Saudi hospitality in the heart of Al Khobar.',
            style: GoogleFonts.poppins(
              color: FooterSection._cream.withValues(alpha: 0.7),
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: FooterSection._gold,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        for (final item in items) ...[
          Text(
            item,
            style: GoogleFonts.poppins(
              color: FooterSection._cream.withValues(alpha: 0.7),
              fontSize: 13,
              height: 1.8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
