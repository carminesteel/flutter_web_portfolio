import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/components/mouse_coordinator.dart';
import 'package:flutter_web_portfolio/constants/file_path.dart';

class InteractiveWidget extends StatefulWidget {
  const InteractiveWidget({
    required this.profileImageKey,
    required this.x,
    required this.y,
    super.key,
  });

  final GlobalKey profileImageKey;
  final double x;
  final double y;

  @override
  State<InteractiveWidget> createState() => _InteractiveWidgetState();
}

class _InteractiveWidgetState extends State<InteractiveWidget>
    with SingleTickerProviderStateMixin {
  bool isTriggered = false;

  //controller
  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ));

  //spin 애니메이션
  late final rotate = Tween<double>(begin: 0, end: 3.14).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0,
        0.5,
        curve: Curves.easeOutCubic,
      ),
      reverseCurve: const Interval(
        0.5,
        1,
        curve: Curves.easeInCubic,
      ),
    ),
  );

  //width 애니메이션
  // late final expandWidth =
  //     Tween<double>(begin: 1600 / 2.5, end: MediaQuery.of(context).size.width)
  //         .animate(
  //   CurvedAnimation(
  //       parent: _animationController,
  //       curve: const Interval(
  //         0.250,
  //         0.500,
  //         curve: Curves.easeOutCubic,
  //       )),
  // );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () async {
            if (!isTriggered) {
              await _animationController.forward();
              setState(() {
                isTriggered = true;
              });
            } else {
              await _animationController.reverse();
              setState(() {
                isTriggered = false;
              });
            }
          },
          child: Transform(
            transform: Matrix4(
              1, 0, 0, 0,
              //
              0, 1, 0, 0,
              //
              0, 0, 1, -0.001,
              //
              0, 0, 0, 1,
              //
            )
              ..rotateX(widget.x)
              ..rotateY(
                rotate.value - widget.y,
                // 180 * pi / 180,
              ),
            alignment: FractionalOffset.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                '$PHOTO/main_profile.jpg',
                key: widget.profileImageKey,
                fit: BoxFit.contain,
                width: 1600 / 2.5,
                height: 900 / 2.5,
              ),
            ),
          ),
        );
      },
    );
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}
