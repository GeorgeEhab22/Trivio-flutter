// auth_shell.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/custom_bottom_navigation_bar.dart';

class AuthShell extends StatelessWidget {
  // Either a child (for ShellRoute) OR a navigationShell (for StatefulShellRoute.indexedStack)
  final Widget? child;
  final dynamic navigationShell; // dynamic to avoid version/type issues with go_router internals

  const AuthShell({
    this.child,
    this.navigationShell,
    super.key,
  }) : assert(
          child != null || navigationShell != null,
          'Either child or navigationShell must be provided',
        );

  // Canonical index <-> route
  static const Map<int, String> indexToRoute = {
    0: AppRoutes.home,
    1: AppRoutes.reels,
    2: AppRoutes.chatbot,
    3: AppRoutes.stats,
    4: AppRoutes.profile,
  };

  static int locationToIndex(String location) {
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.reels)) return 1;
    if (location.startsWith(AppRoutes.chatbot)) return 2;
    if (location.startsWith(AppRoutes.stats)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }

  void _goToIndexWithShell(dynamic navShell, int idx) {
    if (idx < 0 || idx >= indexToRoute.length) return;
    try {
      navShell.goBranch(idx, initialLocation: true);
    } catch (_) {
      // optional: log error
    }
  }

  void _goToIndexWithRouter(BuildContext context, int idx) {
    final route = indexToRoute[idx];
    if (route == null) return;
    GoRouter.of(context).go(route);
  }

  void _onSwipe(BuildContext context, bool left) {
    if (navigationShell != null) {
      int currentIndex;

      try {
        // primary source of truth in indexedStack mode
        currentIndex = navigationShell.currentIndex as int;
      } catch (_) {
        // fallback: derive from current URI
        final location = GoRouterState.of(context).uri.toString();
        currentIndex = locationToIndex(location);
      }

      final newIndex = left ? currentIndex + 1 : currentIndex - 1;
      if (newIndex < 0 || newIndex > indexToRoute.length - 1) return;
      _goToIndexWithShell(navigationShell, newIndex);
      return;
    }

    // Non-shell fallback
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = locationToIndex(location);
    final newIndex = left ? currentIndex + 1 : currentIndex - 1;
    if (newIndex < 0 || newIndex > indexToRoute.length - 1) return;
    _goToIndexWithRouter(context, newIndex);
  }

  @override
  Widget build(BuildContext context) {
    // Determine currentIndex for bottom nav
    int currentIndex;
    if (navigationShell != null) {
      try {
        currentIndex = navigationShell.currentIndex as int;
      } catch (_) {
        currentIndex =
            locationToIndex(GoRouterState.of(context).uri.toString());
      }
    } else {
      currentIndex = locationToIndex(GoRouterState.of(context).uri.toString());
    }

    // swipe detection thresholds
    const velocityThreshold = 500.0;
    const distanceThreshold = 80.0;
    double dragDelta = 0.0;

    final Widget body =
        navigationShell != null ? (navigationShell as Widget) : (child ?? const SizedBox.shrink());

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
                ..onStart = (_) {
                  dragDelta = 0.0;
                }
                ..onUpdate = (details) {
                  dragDelta += details.delta.dx;
                }
                ..onEnd = (details) {
                  final vx = details.velocity.pixelsPerSecond.dx;
                  if (vx.abs() >= velocityThreshold) {
                    _onSwipe(context, vx < 0);
                    return;
                  }

                  if (dragDelta.abs() >= distanceThreshold) {
                    _onSwipe(context, dragDelta < 0);
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
        onTapIndex: navigationShell != null
            ? (idx) => _goToIndexWithShell(navigationShell, idx)
            : null,
      ),
    );
  }
}
