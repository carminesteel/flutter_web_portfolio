import 'package:flutter/material.dart';

class MouseCoordinator extends StatefulWidget {
  const MouseCoordinator({
    required this.child,
    required this.onPositionChange,
    super.key,
  });

  final Widget child;
  final Function(Offset offset) onPositionChange;

  @override
  State<MouseCoordinator> createState() => _MouseCoordinatorState();
}

class _MouseCoordinatorState extends State<MouseCoordinator> {
  void _updateLocation(PointerEvent details) {
    widget.onPositionChange(details.position);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _updateLocation,
      child: widget.child,
    );
  }
}
