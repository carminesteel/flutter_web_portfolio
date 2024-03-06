import 'dart:developer';

import 'package:flutter/material.dart';

class BottomControlPanel extends StatefulWidget {
  const BottomControlPanel({super.key});

  @override
  State<BottomControlPanel> createState() => _BottomControlPanelState();
}

class _BottomControlPanelState extends State<BottomControlPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  late final Animation<double> width =
      Tween<double>(begin: 10, end: 1800).animate(CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.3, 1, curve: Curves.easeOutExpo),
  ));

  @override
  void initState() {
    _controller
      ..forward(from: 0)
      ..repeat();
    super.initState();
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
        return Positioned(
            bottom: 50,
            width: width.value,
            child: Center(
              child: const Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ));
      },
    );
  }
}
