import 'package:flutter/cupertino.dart';

class ActionProvider extends ChangeNotifier {
  static bool _isTriggered = false;

  bool get isTriggered => _isTriggered;

  void switchTriggered() {
    _isTriggered = !_isTriggered;
    notifyListeners();
  }
}
