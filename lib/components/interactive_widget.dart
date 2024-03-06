import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/common/colors.dart';
import 'package:flutter_web_portfolio/common/utils.dart';
import 'package:flutter_web_portfolio/components/mouse_coordinator.dart';
import 'package:flutter_web_portfolio/constants/file_path.dart';
import 'package:flutter_web_portfolio/provider/action_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class InteractiveWidget extends StatefulWidget {
  const InteractiveWidget({
    required this.profileImageKey,
    required this.x,
    required this.y,
    super.key,
  });

  // 글로벌 키를 사용하여 위젯의 절대적인 위치를 파악하기 위함.
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

  // 메인 프로필사진이 뒤집혔을 때 노출시킬 위젯.
  Widget _buildFlippedContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor.toneGray,
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
            // 클릭을 실시하면 뒤집히는 애니메이션 수행, 완료 후 확장되면서 라우팅을 실시.
            if (!_animationController.isAnimating && !_provider.isTriggered) {
              _provider.switchTriggered();
              // 뒤집기
              await _animationController.forward();
              // 확장하기
              await _scaleAnimationController.forward().then((_) {
                // 다음 화면으로 라우팅.
                context.go(
                  '/profile',
                );
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
              // 마우스 포지션에 따라 약간 기울도록 처리한다.
              ..rotateX(scale.value != 1.0 ? 0 : widget.x)
              ..rotateY(
                scale.value != 1.0 ? 0 : rotate.value - widget.y,
              )
              // 스케일 처리.
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

// 글로벌 키를 통해 현재 화면에서 렌더된 영역의 오프셋을 구한다.
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
