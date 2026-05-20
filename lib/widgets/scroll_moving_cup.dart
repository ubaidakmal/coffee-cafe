import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'hover_reveal_cup.dart';

class ScrollMovingCup extends StatefulWidget {
  const ScrollMovingCup({
    required this.progress,
    required this.stageWidth,
    required this.heroHeight,
    required this.aboutHeight,
    required this.imagePath,
    required this.revealPath,
    super.key,
  });

  final double progress;
  final double stageWidth;
  final double heroHeight;
  final double aboutHeight;
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
    final eased = Curves.easeInOutCubic.transform(
      widget.progress.clamp(0.0, 1.0),
    );
    final size = widget.stageWidth < 980 ? 520.0 : 600.0;
    final heroLeft = widget.stageWidth - 310 - size;
    final aboutLeft = (widget.stageWidth * 0.12 - size * 0.22).clamp(
      -58.0,
      120.0,
    );
    final top = lerpDouble(
      10,
      widget.heroHeight + widget.aboutHeight * 0.22,
      eased,
    )!;
    final left = lerpDouble(heroLeft, aboutLeft, eased)!;
    final scale = lerpDouble(1, 1.06, eased)!;
    final rotate = lerpDouble(0, 0.0, eased)!;
    final canReveal = widget.progress < 0.42;

    return Positioned(
      left: left,
      top: top,
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
                    height: size * 1,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
          ),
        ),
      ),
    );
  }
}
