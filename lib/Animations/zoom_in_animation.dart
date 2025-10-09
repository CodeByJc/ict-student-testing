import 'package:flutter/material.dart';

class ZoomInAnimation extends StatefulWidget {
  final Widget child;
  final int delayMilliseconds;

  const ZoomInAnimation({
    super.key,
    required this.child,
    this.delayMilliseconds = 200, // Customize delay for each item if needed
  });

  @override
  // ignore: library_private_types_in_public_api
  _ZoomInAnimationState createState() => _ZoomInAnimationState();
}

class _ZoomInAnimationState extends State<ZoomInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200), // Duration of the zoom effect
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation with a delay
    Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
