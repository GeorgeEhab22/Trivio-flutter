import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auth/core/styels.dart';

class GroupSearchField extends StatefulWidget {
  final String hintText;
  final Function(String) onSearch;

  const GroupSearchField({
    super.key,
    required this.hintText,
    required this.onSearch,
  });

  @override
  State<GroupSearchField> createState() => _GroupSearchFieldState();
}

class _GroupSearchFieldState extends State<GroupSearchField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        onChanged: (query) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 700), () {
            widget.onSearch(query);
          });
        },
        decoration: InputDecoration(
          icon: const Icon(Icons.search, size: 22),
          hintText: widget.hintText,
          hintStyle: Styles.textStyle16.copyWith(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
