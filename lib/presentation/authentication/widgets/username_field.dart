import 'package:auth/core/validator.dart';
import 'package:auth/presentation/authentication/widgets/requirement_indecator.dart';
import 'package:flutter/material.dart';
import 'package:auth/core/vanishing_item.dart';
import 'package:auth/core/vanishing_item_controller.dart';

class UsernameField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmit;
  final bool showValidation;

  const UsernameField({
    super.key,
    required this.controller,
    this.onSubmit,
    this.showValidation = true,
  });

  @override
  State<UsernameField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends State<UsernameField> {
  late final VanishingItemController<String> _vanishingController;
  late final Validator regEx;

  final _requirements = <String, Requirement>{
    'minLength': Requirement(
      label: 'At least 3 characters',
      check: (username) => username.length >= 3,
    ),
    'noSpaces': Requirement(
      label: 'No spaces allowed',
      check: (username) => !username.contains(' '),
    ),
    'validChars': Requirement(
      label: 'Only letters, numbers, and underscores',
      check: (username) =>
          Validator.isValidUsername(username),
    ),
  };

  String? _errorText;
  bool _hasTouched = false;

  @override
  void initState() {
    super.initState();
    _vanishingController = VanishingItemController<String>();
    widget.controller.addListener(_validateUsername);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateUsername);
    _vanishingController.dispose();
    super.dispose();
  }

  void _validateUsername() {
    final username = widget.controller.text.trim();
    if (username.isNotEmpty) _hasTouched = true;
    if (_errorText != null) {
      final newError = _defaultValidator(username);
      if (newError == null) {
        setState(() => _errorText = null);
      } else if (newError != _errorText) {
        setState(() => _errorText = newError);
      }
    }

    bool shouldRebuild = false;

    for (final entry in _requirements.entries) {
      final key = entry.key;
      final req = entry.value;

      final oldMet = req.isMet;
      final newMet = req.check(username);

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

  bool get _allRequirementsMet => _requirements.values.every((r) => r.isMet);

  bool get _hasBrokenRequirements =>
      _requirements.values.any((r) => r.wasMet && !r.isMet);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showErrors =
        widget.showValidation && _hasTouched && _hasBrokenRequirements;

    final allValid = _allRequirementsMet && _hasTouched;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => widget.onSubmit?.call(),
          decoration: InputDecoration(
            labelText: "Username",
            hintText: "Enter your username",
            errorText: _errorText,
            suffixIcon: allValid
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : null,
          ).applyDefaults(theme.inputDecorationTheme),
          validator: (value){
             final error = _defaultValidator(value);
            setState(() => _errorText = error);
            return error;
          },
        ),
        if (showErrors) ...[
          const SizedBox(height: 8),
          for (final entry in _requirements.entries)
            if (entry.value.wasMet && !entry.value.isMet)
              VanishingItem(
                isVisible: !_vanishingController.isHidden(entry.key),
                child: RequirementIndicator(
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
    if (trimmed.isEmpty) return "Username is required";
    if (trimmed.length < 3) return "Username must be at least 3 characters";
    if (!Validator.isValidUsername(trimmed)) {
      return "Only letters, numbers, and underscores are allowed";
    }
    return null;
  }
}
