import 'package:flutter/material.dart';

class SlideInAnimation extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;

  const SlideInAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.offset = const Offset(0, 0.3),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 50),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class ScaleAnimation extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const ScaleAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class FadeInAnimation extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeIn,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class BounceAnimation extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const BounceAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.bounceOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * -50),
          child: child,
        );
      },
      child: child,
    );
  }
}

class RotateAnimation extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final int rotations;

  const RotateAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.rotations = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: duration,
      tween: Tween(begin: 0.0, end: rotations * 2 * 3.14159),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value,
          child: child,
        );
      },
      child: child,
    );
  }
}