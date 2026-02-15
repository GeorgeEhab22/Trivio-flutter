import 'package:auth/core/validator.dart';
import 'package:auth/l10n/app_localizations.dart';
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
  
  late final Map<String, Requirement> _requirements;
  bool _requirementsInitialized = false;

  String? _errorText;
  bool _hasTouched = false;

  @override
  void initState() {
    super.initState();
    _vanishingController = VanishingItemController<String>();
    widget.controller.addListener(_validateUsername);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_requirementsInitialized) {
      final l10n = AppLocalizations.of(context)!;
      _requirements = {
        'minLength': Requirement(
          label: l10n.reqUsernameMinLength,
          check: (username) => username.length >= 3,
        ),
        'noSpaces': Requirement(
          label: l10n.reqNoSpaces,
          check: (username) => !username.contains(' '),
        ),
        'validChars': Requirement(
          label: l10n.reqUsernameChars,
          check: (username) => Validator.isValidUsername(username),
        ),
      };
      _requirementsInitialized = true;
    }
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
      final newError = _localizedValidator(username);
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
  bool get _hasBrokenRequirements => _requirements.values.any((r) => r.wasMet && !r.isMet);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final showErrors = widget.showValidation && _hasTouched && _hasBrokenRequirements;
    final allValid = _allRequirementsMet && _hasTouched;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => widget.onSubmit?.call(),
          decoration: InputDecoration(
            labelText: l10n.labelUsername,
            hintText: l10n.hintUsername,
            errorText: _errorText,
            suffixIcon: allValid
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ).applyDefaults(theme.inputDecorationTheme),
          validator: (value) {
            final error = _localizedValidator(value);
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

  String? _localizedValidator(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return l10n.errUsernameRequired;
    if (trimmed.length < 3) return l10n.errUsernameTooShort;
    if (!Validator.isValidUsername(trimmed)) return l10n.errUsernameChars;
    return null;
  }
}