import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension NumberLocalization on num {
  String localize(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return NumberFormat.decimalPattern(locale).format(this);
  }
}

extension StringNumberLocalization on String {
  String localizeDigits(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale != 'ar') return this;

    const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = this;
    for (int i = 0; i < englishDigits.length; i++) {
      result = result.replaceAll(englishDigits[i], arabicDigits[i]);
    }
    return result;
  }
}