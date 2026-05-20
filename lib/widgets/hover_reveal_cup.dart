import 'dart:ui' show ImageFilter, lerpDouble;

import 'package:flutter/material.dart';

class HoverRevealCup extends StatefulWidget {
  const HoverRevealCup({
    required this.normalSrc,
    required this.revealSrc,
    required this.size,
    required this.semanticLabel,
    this.revealed = false,
    this.onRevealToggle,
    this.revealScale = 1.08,
    super.key,
  });

  final String normalSrc;
  final String revealSrc;
  final String semanticLabel;
  final double size;
  final bool revealed;
  final double revealScale;
  final ValueChanged<bool>? onRevealToggle;

  @override
  State<HoverRevealCup> createState() => _HoverRevealCupState();
}

class _HoverRevealCupState extends State<HoverRevealCup>
    with SingleTickerProviderStateMixin {
  static const Curve _motionCurve = Cubic(0.16, 1, 0.3, 1);

  late final AnimationController _controller;
  bool _hovered = false;

  bool get _isRevealed => _hovered || widget.revealed;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
      reverseDuration: const Duration(milliseconds: 430),
    );

    if (_isRevealed) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant HoverRevealCup oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setHovered(bool value) {
    if (_hovered == value) {
      return;
    }

    setState(() => _hovered = value);
    _syncController();
  }

  void _syncController() {
    if (!mounted) {
      return;
    }

    if (_isRevealed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _toggleReveal() {
    widget.onRevealToggle?.call(!widget.revealed);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _toggleReveal,
        child: Semantics(
          button: true,
          label: widget.semanticLabel,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = _motionCurve.transform(_controller.value);
              final normalOpacity = lerpDouble(1, 0, progress)!;
              final normalScale = lerpDouble(1, 0.985, progress)!;
              final revealOpacity = progress;
              final revealScale = lerpDouble(
                0.92,
                widget.revealScale,
                progress,
              )!;
              final revealY = lerpDouble(22, -14, progress)!;
              final liftY = lerpDouble(0, -10, progress)!;
              final blur = lerpDouble(2, 0, progress)!;

              return Transform.translate(
                offset: Offset(0, liftY),
                child: SizedBox(
                  width: widget.size,
                  height: widget.size * 1.14,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Transform.scale(
                        scale: normalScale,
                        alignment: Alignment.bottomCenter,
                        child: Opacity(
                          opacity: normalOpacity,
                          child: Image.asset(
                            widget.normalSrc,
                            width: widget.size,
                            height: widget.size * 1.14,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: revealOpacity,
                            child: Transform.translate(
                              offset: Offset(0, revealY),
                              child: Transform.scale(
                                scale: revealScale,
                                alignment: Alignment.bottomCenter,
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: blur,
                                    sigmaY: blur,
                                  ),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: const Color(0xFFC9922A)
                                      //         .withValues(
                                      //           alpha: 0.08 * revealOpacity,
                                      //         ),
                                      //     blurRadius: widget.size * 0.08,
                                      //     spreadRadius: widget.size * 0.002,
                                      //   ),
                                      //   BoxShadow(
                                      //     color: const Color(0xFF2A1005)
                                      //         .withValues(
                                      //           alpha: 0.09 * revealOpacity,
                                      //         ),
                                      //     blurRadius: widget.size * 0.06,
                                      //     offset: Offset(0, widget.size * 0.03),
                                      //   ),
                                      // ],
                                    ),
                                    child: Image.asset(
                                      widget.revealSrc,
                                      width: widget.size,
                                      height: widget.size * 1.14,
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
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
            },
          ),
        ),
      ),
    );
  }
}
