import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/custom_bottom_navigation_bar.dart';

class AuthShell extends StatelessWidget {
  final Widget child;
  const AuthShell({required this.child, super.key});

  // Map index -> route path used by GlassmorphismNav
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

  // Helper to navigate to a given index if valid
  void _goToIndex(BuildContext context, int idx) {
    final route = indexToRoute[idx];
    if (route == null) return;
    GoRouter.of(context).go(route);
  }

  // Called when a swipe is recognized. left = true means user swiped left (want next)
  void _onSwipe(BuildContext context, bool left) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = locationToIndex(location);

    final newIndex = left ? currentIndex + 1 : currentIndex - 1;

    if (newIndex < 0 || newIndex > indexToRoute.length - 1) return;
    _goToIndex(context, newIndex);
  }

  @override
  Widget build(BuildContext context) {
    // current full uri, e.g. "/app/home"
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = locationToIndex(location);



    final isReel = currentIndex == 1;
    // Gesture detection:
    // - Use DragEnd velocity primarily (fast swipes)
    // - Fallback to DragUpdate distance (slow swipe but intentional)
    const velocityThreshold = 500.0; // px/s
    const distanceThreshold = 80.0; // px

    double dragDelta = 0.0; // accumulates horizontal movement during the drag

    return Scaffold(
      backgroundColor: 
      isReel
          ? const Color(0xFF18191a)
          : Theme.of(context).scaffoldBackgroundColor,
      body: RawGestureDetector(
        gestures: {
          // Use a HorizontalDragGestureRecognizer so it doesn't fight with vertical scrolls
          HorizontalDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<
                HorizontalDragGestureRecognizer
              >(
                () =>
                    HorizontalDragGestureRecognizer()
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
                      // If velocity is strong enough, use it
                      if (vx.abs() >= velocityThreshold) {
                        if (vx < 0) {
                          // swipe left (finger moved left) => go to next
                          _onSwipe(context, true);
                        } else {
                          // swipe right => go to previous
                          _onSwipe(context, false);
                        }
                        return;
                      }

                      // Fallback: if the user dragged far enough, treat it as a swipe
                      if (dragDelta.abs() >= distanceThreshold) {
                        if (dragDelta < 0) {
                          // dragged left => next
                          _onSwipe(context, true);
                        } else {
                          // dragged right => previous
                          _onSwipe(context, false);
                        }
                      }
                    };
                },
              ),
        },
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
      bottomNavigationBar: GlassmorphismNav(
        routeForIndex: indexToRoute,
        currentIndex: currentIndex,
      ),
    );
  }
}
