import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({
    required this.progress,
    required this.isWide,
    super.key,
  });

  final double progress;
  final bool isWide;

  static const Color _espresso = Color(0xFF180800);
  static const Color _deepBrown = Color(0xFF2A1005);
  static const Color _gold = Color(0xFFC9922A);
  static const Color _cream = Color(0xFFF5E6CC);
  static const Color _softCream = Color(0xFFF9EFD9);
  static const Color _mutedBrown = Color(0xFF6B4A2A);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final headingSize = width < 420
        ? 38.0
        : width < 760
        ? 46.0
        : 58.0;
    final headerProgress = isWide ? _interval(progress, 0.05, 0.44) : 1.0;
    final contentProgress = isWide ? _interval(progress, 0.22, 1.0) : 1.0;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_softCream, _cream],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: isWide ? -140 : -170,
            top: isWide ? 70 : 110,
            child: _RadialGlow(size: isWide ? 520 : 340, opacity: 0.12),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isWide ? 74 : 54),
            child: Column(
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
                            'CONTACT US',
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
                        constraints: const BoxConstraints(maxWidth: 740),
                        child: Text(
                          'Let\'s bring Koffiqa closer to your next coffee moment.',
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
                        constraints: const BoxConstraints(maxWidth: 660),
                        child: Text(
                          'Visit us at Ajdan Walk or send a note to plan a tasting, '
                          'brand collaboration, or private specialty coffee service.',
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
                SizedBox(height: isWide ? 44 : 30),
                _AnimatedBlock(
                  progress: contentProgress,
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: _ContactInfoPanel()),
                            const SizedBox(width: 28),
                            Expanded(child: _ContactFormCard()),
                          ],
                        )
                      : Column(
                          children: [
                            const _ContactInfoPanel(),
                            const SizedBox(height: 22),
                            _ContactFormCard(),
                          ],
                        ),
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

class _ContactInfoPanel extends StatelessWidget {
  const _ContactInfoPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ContactTile(
          icon: Icons.place_rounded,
          title: 'Visit',
          value: 'Ajdan Walk, Al Khobar, KSA',
        ),
        SizedBox(height: 14),
        _ContactTile(
          icon: Icons.schedule_rounded,
          title: 'Hours',
          value: 'Daily, 8:00 AM - 12:00 AM',
        ),
        SizedBox(height: 14),
        _ContactTile(
          icon: Icons.alternate_email_rounded,
          title: 'Email',
          value: 'hello@koffiqabystacx.sa',
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.36),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ContactSection._gold.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: ContactSection._espresso.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: ContactSection._deepBrown,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: ContactSection._gold, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: ContactSection._deepBrown,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      color: ContactSection._mutedBrown,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactFormCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: ContactSection._gold.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A220C).withValues(alpha: 0.14),
            blurRadius: 70,
            offset: const Offset(0, 28),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const _ContactInput(label: 'Name'),
            const SizedBox(height: 14),
            const _ContactInput(label: 'Email or phone'),
            const SizedBox(height: 14),
            const _ContactInput(label: 'Message', maxLines: 4),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: ContactSection._deepBrown,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Send Message',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: ContactSection._cream,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactInput extends StatelessWidget {
  const _ContactInput({required this.label, this.maxLines = 1});

  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      cursorColor: ContactSection._gold,
      style: GoogleFonts.poppins(
        color: ContactSection._deepBrown,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: ContactSection._mutedBrown,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.48),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ContactSection._gold),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: ContactSection._gold.withValues(alpha: 0.2),
          ),
        ),
      ),
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
      offset: Offset(0, lerpDouble(46, 0, progress)!),
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
            ContactSection._gold.withValues(alpha: opacity),
            ContactSection._gold.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
