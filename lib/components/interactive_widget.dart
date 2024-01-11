import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/components/mouse_coordinator.dart';
import 'package:flutter_web_portfolio/constants/file_path.dart';

class InteractiveWidget extends StatefulWidget {
  const InteractiveWidget({
    super.key,
  });

  @override
  State<InteractiveWidget> createState() => _InteractiveWidgetState();
}

class _InteractiveWidgetState extends State<InteractiveWidget>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final GlobalKey _profileImageKey = GlobalKey();

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

  void _setCenterOffset() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_profileImageKey.globalPaintBounds != null) {
        _widgetCenterOffset = _profileImageKey.globalPaintBounds!.center;
      }
    });
  }

  void _onExit() {
    setState(() {
      x = 0;
      y = 0;
      z = 0;
    });
    _onLongPressUp();
  }

  void _onHover() async {
    _currentAnim = _scaleAnim;
    await _animController.forward();
  }

  void _onLongPressUp() async {
    _currentAnim = _shrinkAnim;
    await _animController.reverse();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    // animtaion controller
    _initAnimationController();

    _setCenterOffset();

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _setCenterOffset();
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return MouseCoordinator(
      onMouseHover: _onHover,
      onExit: _onExit,
      onPositionChange: (offset) {
        setState(() {
          if (_profileImageKey.globalPaintBounds != null) {
            x = ((_widgetCenterOffset - offset).dy) / 1000;
            y = ((_widgetCenterOffset - offset).dx) / 1000;
          }
        });
      },
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
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
              ..rotateX(x)
              ..rotateY(-y)
              ..rotateZ(z),
            alignment: FractionalOffset.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                '$PHOTO/main_profile.jpg',
                key: _profileImageKey,
                fit: BoxFit.contain,
                width: 1600 / 2.5,
                height: 900 / 2.5,
              ),
            ),
          );
        },
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
