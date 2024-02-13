import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 트랜지션 효과 없는 라우팅
NoTransitionPage<T> buildPageWithoutTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return NoTransitionPage<T>(
    key: state.pageKey,
    child: child,

  );
}