import 'package:auth/core/vanishing_item.dart';
import 'package:auth/core/vanishing_item_controller.dart';
import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  final TextEditingController controller;
  final bool isLogin;
  final VoidCallback? onSubmit;
  final String? Function(String?)? validator;
  final bool showValidation;

  const EmailField({
    super.key,
    required this.controller,
    required this.isLogin,
    this.onSubmit,
    this.validator,
    this.showValidation = true,
  });

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  late final VanishingItemController<String> _vanishingController;

  final Map<String, _Requirement> _requirements = {
    'noSpaces': _Requirement(
      label: 'No spaces allowed',
      check: (email) => !email.contains(' '),
    ),
    'atSymbol': _Requirement(
      label: 'Contains @ symbol',
      check: (email) => email.contains('@'),
    ),
    'domain': _Requirement(
      label: 'Valid domain (e.g., example.com)',
      check: (email) {
        final parts = email.split('@');
        return parts.length == 2 && parts[1].contains('.');
      },
    ),
    'validFormat': _Requirement(
      label: 'Valid email format',
      check: (email) => _emailRegex.hasMatch(email),
    ),
  };

  bool _hasTouched = false;

  @override
  void initState() {
    super.initState();
    _vanishingController = VanishingItemController<String>();
    widget.controller.addListener(_validateEmail);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateEmail);
    _vanishingController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = widget.controller.text.trim();
    if (email.isNotEmpty) _hasTouched = true;

    bool shouldRebuild = false;

    for (final entry in _requirements.entries) {
      final key = entry.key;
      final req = entry.value;

      final oldMet = req.isMet;
      final newMet = req.check(email);

      if (oldMet != newMet) {
        req.isMet = newMet;
        shouldRebuild = true;

        if (newMet) {
          req.wasMet = true;
          _vanishingController.scheduleHide(key);
        } else {
          _vanishingController.show(key);
        }
      }
    }

    if (shouldRebuild) setState(() {});
  }

  bool get _hasValidFormat => _requirements['validFormat']!.isMet;

  bool get _hasBrokenRequirements =>
      _requirements.values.any((r) => r.wasMet && !r.isMet);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasErrors = widget.showValidation &&
        !widget.isLogin &&
        _hasTouched &&
        _hasBrokenRequirements;

    final validFormat = _hasValidFormat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => widget.onSubmit?.call(),
          decoration: InputDecoration(
            labelText: 'Email',
            hintText:
                widget.isLogin ? 'Enter username or email' : 'Enter email',
            suffixIcon: validFormat && _hasTouched
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : null,
          ).applyDefaults(theme.inputDecorationTheme),
          validator: widget.validator ?? _defaultValidator,
        ),
        if (hasErrors) ...[
          const SizedBox(height: 8),
          for (final entry in _requirements.entries)
            if (entry.value.wasMet && !entry.value.isMet)
              VanishingItem(
                isVisible: !_vanishingController.isHidden(entry.key),
                child: _RequirementIndicator(
                  label: entry.value.label,
                  isMet: entry.value.isMet,
                ),
              ),
        ],
      ],
    );
  }

  String? _defaultValidator(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return widget.isLogin
          ? 'Please enter your username or email'
          : 'Please enter your email';
    }
    if (!widget.isLogin && !_emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}

class _Requirement {
  final String label;
  final bool Function(String) check;
  bool isMet = false;
  bool wasMet = false;

  _Requirement({required this.label, required this.check});
}

class _RequirementIndicator extends StatelessWidget {
  final String label;
  final bool isMet;

  const _RequirementIndicator({
    required this.label,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isMet ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isMet ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
