import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/common/utils.dart';

class MouseCoordinator extends StatefulWidget {
  const MouseCoordinator({
    required this.child,
    required this.onPositionChange,
    this.onExit,
    this.onLongPress,
    this.onLongPressUp,
    this.onMouseHover,
    super.key,
  });

  final Widget child;
  final void Function(Offset offset) onPositionChange;
  final void Function()? onExit;
  final void Function()? onLongPress;
  final void Function()? onLongPressUp;
  final void Function()? onMouseHover;

  @override
  State<MouseCoordinator> createState() => _MouseCoordinatorState();
}

class _MouseCoordinatorState extends State<MouseCoordinator> {
  void _updateLocation(PointerEvent details) {
    widget.onPositionChange(details.position);
    if (widget.onMouseHover != null) {
      widget.onMouseHover!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: _updateLocation,
      onExit: (event) {
        if (widget.onExit != null) {
          widget.onExit!();
        }
      },
      child: widget.child,
    );
  }
}
