import 'package:flutter/foundation.dart';

class VanishingItemController<T> extends ChangeNotifier {
  final Set<T> _hiddenItems = {};
  final Duration hideDelay;

  VanishingItemController({
    this.hideDelay = const Duration(milliseconds: 300),
  });

  Set<T> get hiddenItems => Set.unmodifiable(_hiddenItems);

  bool isHidden(T item) => _hiddenItems.contains(item);

  void scheduleHide(T item) {
    Future.delayed(hideDelay, () {
      _hiddenItems.add(item);
      notifyListeners();
    });
  }

  void show(T item) {
    if (_hiddenItems.remove(item)) {
      notifyListeners();
    }
  }
  void hideImmediately(T key) {
  _hiddenItems.add(key);
  notifyListeners();
}


  void reset() {
    _hiddenItems.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _hiddenItems.clear();
    super.dispose();
  }
}