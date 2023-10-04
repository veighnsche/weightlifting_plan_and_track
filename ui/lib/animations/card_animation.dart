import 'package:flutter/material.dart';

class CardAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const CardAnimation({
    super.key,
    required this.child,
    required this.duration,
    required this.delay,
  });

  @override
  _CardAnimationState createState() => _CardAnimationState();
}

class _CardAnimationState extends State<CardAnimation>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<CardAnimation> {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    var customTween =
        CurveTween(curve: const Interval(0, 1.0, curve: Curves.easeInOut));

    _opacityAnimation =
        Tween(begin: 0.0, end: 1.0).chain(customTween).animate(_controller);

    _scaleAnimation =
        Tween(begin: 0.8, end: 1.0).chain(customTween).animate(_controller);

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return AnimatedOpacity(
          opacity: _opacityAnimation.value,
          duration: Duration.zero,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
