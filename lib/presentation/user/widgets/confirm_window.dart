import 'package:auth/core/styels.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmWindow extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onConfirm;

  const ConfirmWindow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onConfirm,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onConfirm,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, a1, a2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.5,
            end: 1.0,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutBack)),
          child: BlocProvider(
            create: (context) => di.sl<SignInCubit>(),
            child: ConfirmWindow(
              title: title,
              subtitle: subtitle,
              onConfirm: onConfirm,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // The Box
          Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Styles.textStyle25.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: Styles.textStyle16.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Close window
                          onConfirm(); // Do the logout logic
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(
            top: 0,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.logout_rounded, size: 40, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
