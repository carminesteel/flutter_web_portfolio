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
  double x = 0;
  double y = 0;
  double z = 0;
  double scale = 1;

  Offset _widgetCenterOffset = const Offset(0, 0);
  late final AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _shrinkAnim;
  late Animation<double> _currentAnim;
  Curve curve = Curves.easeOutCirc;

  void _initAnimationController() {
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _scaleAnim = Tween(
      begin: 1.0,
      end: 0.8,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCirc));

    _shrinkAnim = Tween(
      begin: _scaleAnim.value,
      end: 0.8,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeInCirc));

    _currentAnim = _scaleAnim;
  }

  void _onExit() {
    setState(() {
      x = 0;
      y = 0;
      z = 0;
    });
    // _onLongPressUp();
  }

  // void _onHover() async {
  //   _currentAnim = _scaleAnim;
  //   await _animController.forward();
  // }
  //
  // void _onLongPressUp() async {
  //   _currentAnim = _shrinkAnim;
  //   await _animController.reverse();
  // }

  @override
  void didUpdateWidget(covariant InteractiveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // animtaion controller
    _initAnimationController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4(
        1, 0, 0, 0,
        //
        0, 1, 0, 0,
        //
        0, 0, 1, -0.001,
        //
        0, 0, 0, _currentAnim.value,
        //
      )
        ..rotateX(widget.x)
        ..rotateY(-(widget.y))
        ..rotateZ(z),
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
