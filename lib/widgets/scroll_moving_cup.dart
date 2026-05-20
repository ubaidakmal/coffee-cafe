import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'hover_reveal_cup.dart';

class ScrollMovingCup extends StatefulWidget {
  const ScrollMovingCup({
    required this.progress,
    required this.stageWidth,
    required this.heroHeight,
    required this.aboutHeight,
    required this.productsHeight,
    required this.imagePath,
    required this.revealPath,
    super.key,
  });

  final double progress;
  final double stageWidth;
  final double heroHeight;
  final double aboutHeight;
  final double productsHeight;
  final String imagePath;
  final String revealPath;

  @override
  State<ScrollMovingCup> createState() => _ScrollMovingCupState();
}

class _ScrollMovingCupState extends State<ScrollMovingCup> {
  bool _revealed = false;

  @override
  void didUpdateWidget(covariant ScrollMovingCup oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.progress >= 0.42 && _revealed) {
      _revealed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final aboutProgress = Curves.easeInOutCubic.transform(
      widget.progress.clamp(0.0, 1.0),
    );
    final productProgress = Curves.easeInOutCubic.transform(
      (widget.progress - 1).clamp(0.0, 1.0),
    );
    final baseSize = widget.stageWidth < 980 ? 520.0 : 550.0;
    final cardWidth = (widget.stageWidth - 48) / 3;
    final productSize = (cardWidth * 0.72).clamp(230.0, 315.0);
    final size = lerpDouble(baseSize, productSize, productProgress)!;
    final heroLeft = widget.stageWidth - 100 - baseSize;
    final aboutLeft = (widget.stageWidth * 0.12 - baseSize * 0.22).clamp(
      -58.0,
      120.0,
    );
    final productLeft = cardWidth + 24 + (cardWidth - productSize) / 2;
    final aboutTop = lerpDouble(
      10,
      widget.heroHeight + widget.aboutHeight * 0.22,
      aboutProgress,
    )!;
    final productTop =
        widget.heroHeight + widget.aboutHeight + widget.productsHeight * 0.32;
    final left = widget.progress <= 1
        ? lerpDouble(heroLeft, aboutLeft, aboutProgress)!
        : lerpDouble(aboutLeft, productLeft, productProgress)!;
    final top = widget.progress <= 1
        ? aboutTop
        : lerpDouble(aboutTop, productTop, productProgress)!;
    final scale = widget.progress <= 1
        ? lerpDouble(1, 1.06, aboutProgress)!
        : lerpDouble(1.06, 1, productProgress)!;
    final rotate = lerpDouble(0, -0.035, productProgress)!;
    final canReveal = widget.progress < 0.42;
    final opacity = widget.progress < 1.84
        ? 1.0
        : lerpDouble(1, 0, ((widget.progress - 1.84) / 0.16).clamp(0.0, 1.0))!;

    return Positioned(
      left: left,
      top: top,
      child: IgnorePointer(
        ignoring: opacity < 0.05,
        child: Opacity(
          opacity: opacity,
          child: Transform.rotate(
            angle: rotate,
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.bottomCenter,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size * 0.08),

                ),
                child: canReveal
                    ? HoverRevealCup(
                        normalSrc: widget.imagePath,
                        revealSrc: widget.revealPath,
                        semanticLabel: 'Cream Koffiqa cup',
                        size: size,
                        revealed: _revealed,
                        revealScale: 1.08,
                        onRevealToggle: (revealed) {
                          setState(() => _revealed = revealed);
                        },
                      )
                    : Image.asset(
                        widget.imagePath,
                        width: size,
                        height: size * 1.14,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
