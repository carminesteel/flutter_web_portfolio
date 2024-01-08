import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/components/mouse_coordinator.dart';
import 'package:flutter_web_portfolio/constants/file_path.dart';

import 'package:provider/provider.dart';

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

class InteractiveWidget extends StatefulWidget {
  const InteractiveWidget({
    super.key,
  });

  @override
  State<InteractiveWidget> createState() => _InteractiveWidgetState();
}

class _InteractiveWidgetState extends State<InteractiveWidget> {
  final GlobalKey _profileImageKey = GlobalKey();

  double x = 0;
  double y = 0;
  double z = 0;

  late Offset _initialWidgetOffset;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_profileImageKey.globalPaintBounds != null) {
        _initialWidgetOffset = _profileImageKey.globalPaintBounds!.center;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseCoordinator(
      onPositionChange: (offset) {
        if (_profileImageKey.globalPaintBounds != null) {
          x = ((_initialWidgetOffset - offset).dy) / 1000;
          y = ((_initialWidgetOffset - offset).dx) / 1000;
        }

        setState(() {});
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
          ..rotateX(x)
          ..rotateY(-y)
          ..rotateZ(z),
        alignment: FractionalOffset.center,
        child: Image.asset(
          '$PHOTO/main_profile.jpg',
          key: _profileImageKey,
          fit: BoxFit.contain,
          width: 1600 / 2,
          height: 900 / 2,
        ),
      ),
    );
  }
}
