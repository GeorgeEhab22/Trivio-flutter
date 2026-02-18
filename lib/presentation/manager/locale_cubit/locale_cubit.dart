import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  void toggleLocale() async {
    final newLocale = state.languageCode == 'en' 
        ? const Locale('ar') 
        : const Locale('en');
    
    emit(newLocale);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLocale.languageCode);
  }

  void _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('language_code') ?? 'en';
    emit(Locale(code));
  }
}