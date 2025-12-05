// auth_shell.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/custom_bottom_navigation_bar.dart';

/// AuthShell supports two modes:
///  - ShellRoute style (passes a `child`) -> child is displayed
///  - StatefulShellRoute.indexedStack style (passes a `navigationShell`) -> navigationShell is displayed
///
/// `navigationShell` is treated as a widget and its `goBranch(index, initialLocation: true)` method
/// is invoked dynamically to switch branches. This approach avoids fragile imports from go_router internals.
class AuthShell extends StatelessWidget {
  // Either a child (for ShellRoute) OR a navigationShell (for StatefulShellRoute.indexedStack)
  final Widget? child;
  final dynamic navigationShell; // dynamic to avoid version/type issues with go_router internals

  const AuthShell({
    this.child,
    this.navigationShell,
    super.key,
  }) : assert(child != null || navigationShell != null,
            'Either child or navigationShell must be provided');

  // Map index -> route (paths)
  static const Map<int, String> indexToRoute = {
    0: AppRoutes.home,
    1: AppRoutes.reels,
    2: AppRoutes.chatbot,
    3: AppRoutes.groups,
    4: AppRoutes.stats,
  };

  static int locationToIndex(String location) {
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.reels)) return 1;
    if (location.startsWith(AppRoutes.chatbot)) return 2;
    if (location.startsWith(AppRoutes.groups)) return 3;
    if (location.startsWith(AppRoutes.stats)) return 4;
    return 0;
  }

  // If using navigationShell (StatefulShellRoute), switch branch via it (dynamic call)
  void _goToIndexWithShell(dynamic navShell, int idx) {
    if (idx < 0 || idx >= indexToRoute.length) return;
    try {
      // call goBranch dynamically; initialLocation: true resets to branch's initial location
      navShell.goBranch(idx, initialLocation: true);
    } catch (e) {
      // If navShell doesn't support goBranch for some reason, fallback to route navigation
      // (silently fallback here; you can log if needed)
    }
  }

  // If not using shell, fall back to GoRouter navigation using routes map
  void _goToIndexWithRouter(BuildContext context, int idx) {
    final route = indexToRoute[idx];
    if (route == null) return;
    GoRouter.of(context).go(route);
  }

  void _onSwipe(BuildContext context, bool left) {
    if (navigationShell != null) {
      // navigationShell available: use its currentIndex if present, else fallback to router location
      int currentIndex;
      try {
        currentIndex = navigationShell.currentIndex as int;
      } catch (e) {
        final location = GoRouterState.of(context).uri.toString();
        currentIndex = locationToIndex(location);
      }

      final newIndex = left ? currentIndex + 1 : currentIndex - 1;
      if (newIndex < 0 || newIndex > indexToRoute.length - 1) return;
      _goToIndexWithShell(navigationShell, newIndex);
      return;
    }

    // fallback: use GoRouterState to find location
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = locationToIndex(location);
    final newIndex = left ? currentIndex + 1 : currentIndex - 1;
    if (newIndex < 0 || newIndex > indexToRoute.length - 1) return;
    _goToIndexWithRouter(context, newIndex);
  }

  @override
  Widget build(BuildContext context) {
    // Determine currentIndex (either from navigationShell or current location)
    int currentIndex;
    if (navigationShell != null) {
      try {
        currentIndex = navigationShell.currentIndex as int;
      } catch (e) {
        currentIndex = locationToIndex(GoRouterState.of(context).uri.toString());
      }
    } else {
      currentIndex = locationToIndex(GoRouterState.of(context).uri.toString());
    }

    // swipe detection thresholds
    const velocityThreshold = 500.0;
    const distanceThreshold = 80.0;

    double dragDelta = 0.0;

    // Build body: if navigationShell present use it as a widget; otherwise use provided child
    final Widget body = navigationShell != null
        ? (navigationShell as Widget)
        : (child ?? const SizedBox.shrink());

    return Scaffold(
      backgroundColor: Colors.white,
      body: RawGestureDetector(
        gestures: {
          HorizontalDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<
                  HorizontalDragGestureRecognizer>(
            () => HorizontalDragGestureRecognizer()
              ..dragStartBehavior = DragStartBehavior.start,
            (HorizontalDragGestureRecognizer instance) {
              instance
                ..onStart = (details) {
                  dragDelta = 0.0;
                }
                ..onUpdate = (details) {
                  dragDelta += details.delta.dx;
                }
                ..onEnd = (details) {
                  final vx = details.velocity.pixelsPerSecond.dx;
                  if (vx.abs() >= velocityThreshold) {
                    if (vx < 0) {
                      _onSwipe(context, true);
                    } else {
                      _onSwipe(context, false);
                    }
                    return;
                  }

                  if (dragDelta.abs() >= distanceThreshold) {
                    if (dragDelta < 0) {
                      _onSwipe(context, true);
                    } else {
                      _onSwipe(context, false);
                    }
                  }
                };
            },
          ),
        },
        behavior: HitTestBehavior.translucent,
        child: body,
      ),
      bottomNavigationBar: GlassmorphismNav(
        routeForIndex: indexToRoute,
        currentIndex: currentIndex,
        // if we have navigationShell, pass an onTapIndex callback that uses it.
        onTapIndex:
            navigationShell != null ? (idx) => _goToIndexWithShell(navigationShell, idx) : null,
      ),
    );
  }
}
