import 'package:flutter/material.dart';

class SlideZoomInAnimation extends StatefulWidget {
  final Widget child;
  final int delayMilliseconds;

  const SlideZoomInAnimation({
    super.key,
    required this.child,
    this.delayMilliseconds = 200, // Customize delay for each item if needed
  });

  @override
  _SlideZoomInAnimationState createState() => _SlideZoomInAnimationState();
}

class _SlideZoomInAnimationState extends State<SlideZoomInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Duration of the animation
      vsync: this,
    );

    // Scale animation: Zoom in from 0 to 1
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Slide animation: Move from bottom (Offset(0, 1)) to original position (Offset(0, 0))
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start below the screen
      end: Offset.zero, // End at original position
    ).animate(
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideAnimation.value * 300, // Adjust multiplier for distance
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: widget.child,
          ),
        );
      },
      child: widget.child,
    );
  }
}