import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;
  
  ThemeCubit(this._prefs) : super(ThemeState(
    mode: _getInitialThemeMode(_prefs),
    isAnimating: false,
  ));

  static ThemeMode _getInitialThemeMode(SharedPreferences prefs) {
    final themeModeString = prefs.getString('theme_mode') ?? 'system';
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == 'ThemeMode.$themeModeString',
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    // Start animation
    emit(state.copyWith(isAnimating: true));
    
    // Small delay to allow animation to start
    await Future.delayed(const Duration(milliseconds: 50));
    
    // Change theme
    emit(state.copyWith(mode: mode, isAnimating: true));
    
    // Save to preferences
    await _prefs.setString('theme_mode', mode.toString().split('.').last);
    
    // End animation after transition completes
    await Future.delayed(const Duration(milliseconds: 400));
    emit(state.copyWith(isAnimating: false));
  }

  void toggleTheme() {
    final newMode = state.mode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    setThemeMode(newMode);
  }
}

class ThemeState {
  final ThemeMode mode;
  final bool isAnimating;

  ThemeState({
    required this.mode,
    required this.isAnimating,
  });

  ThemeState copyWith({
    ThemeMode? mode,
    bool? isAnimating,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}