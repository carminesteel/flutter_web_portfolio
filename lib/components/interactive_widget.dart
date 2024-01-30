import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/common/utils.dart';
import 'package:flutter_web_portfolio/components/mouse_coordinator.dart';
import 'package:flutter_web_portfolio/constants/file_path.dart';
import 'package:flutter_web_portfolio/provider/action_provider.dart';
import 'package:provider/provider.dart';

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
    with TickerProviderStateMixin {
  ActionProvider get _provider => context.read<ActionProvider>();
  bool get isTriggered => context.read<ActionProvider>().isTriggered;

  //controller
  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ));

  late final AnimationController _scaleAnimationController =
      AnimationController(
          vsync: this,
          duration: const Duration(
            milliseconds: 500,
          ));

  //scale
  late final scale = Tween<double>(begin: 1, end: 3).animate(
    CurvedAnimation(
        parent: _scaleAnimationController, curve: Curves.easeOutExpo),
  );

  //spin
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

  Widget _buildFlippedContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black38,
      ),
      width: 1600 / 2.5,
      height: 900 / 2.5,
    );
  }

  Widget _buildEntryContainer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        '$PHOTO/main_profile.jpg',
        key: widget.profileImageKey,
        fit: BoxFit.contain,
        width: 1600 / 2.5,
        height: 900 / 2.5,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          Listenable.merge([_animationController, _scaleAnimationController]),
      builder: (context, child) {
        return GestureDetector(
          onTap: () async {
            if (!_animationController.isAnimating && !_provider.isTriggered) {
              _provider.switchTriggered();
              _animationController.forward().then((_) {
                //start expanding animation
                _scaleAnimationController.forward();
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
              ..rotateX(scale.value != 1.0 ? 0 : widget.x)
              ..rotateY(
                scale.value != 1.0 ? 0 : rotate.value - widget.y,
              )
              ..scale(scale.value),
            alignment: FractionalOffset.center,
            child: (rotate.value - widget.y) > 1.7
                ? _buildFlippedContainer()
                : _buildEntryContainer(),
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
