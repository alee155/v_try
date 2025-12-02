import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget child;
  final BorderRadius? borderRadius;
  final double blurSigmaX;
  final double blurSigmaY;
  final List<Color>? gradientColors;

  const GlassContainer({
    Key? key,
    required this.child,
    this.height,
    this.width,
    this.borderRadius,
    this.blurSigmaX = 15,
    this.blurSigmaY = 15,
    this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadius effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(24);

    final List<Color> effectiveGradient =
        gradientColors ??
        [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)];

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigmaX, sigmaY: blurSigmaY),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: effectiveGradient,
              stops: const [0.1, 0.9],
            ),
            borderRadius: effectiveBorderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.15),
                blurRadius: 0,
                spreadRadius: 1,
                offset: const Offset(0, 1),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.08),
                blurRadius: 12,
                spreadRadius: -3,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
