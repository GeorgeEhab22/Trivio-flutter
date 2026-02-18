import 'package:auth/core/validator.dart';
import 'package:auth/core/vanishing_item.dart';
import 'package:auth/core/vanishing_item_controller.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/requirement_indecator.dart';
import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  final TextEditingController controller;
  final bool isLogin;
  final VoidCallback? onSubmit;
  final bool showValidation;

  const EmailField({
    super.key,
    required this.controller,
    required this.isLogin,
    this.onSubmit,
    this.showValidation = true,
  });

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  late final VanishingItemController<String> _vanishingController;
  final _formFieldKey = GlobalKey<FormFieldState>();
  String? _errorText;
  bool _hasTouched = false;

  late Map<String, Requirement> _requirements;
  bool _requirementsInitialized = false;

  @override
  void initState() {
    super.initState();
    _vanishingController = VanishingItemController<String>();
    widget.controller.addListener(_validateEmail);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_requirementsInitialized) {
      final l10n = AppLocalizations.of(context)!;
      _requirements = {
        'noSpaces': Requirement(
          label: l10n.reqNoSpaces,
          check: (email) => !email.contains(' '),
        ),
        'atSymbol': Requirement(
          label: l10n.reqAtSymbol,
          check: (email) => email.contains('@'),
        ),
        'domain': Requirement(
          label: l10n.reqValidDomain,
          check: (email) {
            final parts = email.split('@');
            return parts.length == 2 && parts[1].contains('.');
          },
        ),
        'validFormat': Requirement(
          label: l10n.reqValidFormat,
          check: (email) => Validator.isValidEmail(email),
        ),
      };
      _requirementsInitialized = true;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateEmail);
    _vanishingController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = widget.controller.text.trim();
    if (email.isNotEmpty && _errorText != null) {
      setState(() => _errorText = null);
    }
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
  bool get _hasBrokenRequirements => _requirements.values.any((r) => r.wasMet && !r.isMet);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final input = widget.controller.text.trim();
    final isValidUsername = Validator.isValidUsername(input);
    final isValidEmail = _hasValidFormat;

    final hasErrors = widget.showValidation &&
        !widget.isLogin &&
        _hasTouched &&
        _hasBrokenRequirements &&
        input.isNotEmpty &&
        !isValidEmail;

    final isValid = isValidEmail || (widget.isLogin && isValidUsername);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: _formFieldKey,
          controller: widget.controller,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => widget.onSubmit?.call(),
          decoration: InputDecoration(
            labelText: widget.isLogin ? l10n.labelUsernameEmail : l10n.labelEmail,
            hintText: widget.isLogin ? l10n.hintUsernameEmail : l10n.hintEmail,
            errorText: _errorText,
            suffixIcon: isValid && _hasTouched && !widget.isLogin
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ).applyDefaults(theme.inputDecorationTheme),
          validator: _localizedValidator,
        ),
        if (hasErrors) ...[
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
    
    if (trimmed.isEmpty) {
      final error = widget.isLogin ? l10n.errEmptyLogin : l10n.errEmptyEmail;
      setState(() => _errorText = error);
      return error;
    }

    if (widget.isLogin) {
      if (!Validator.isValidUsername(trimmed) && !Validator.isValidEmail(trimmed)) {
        final error = l10n.errInvalidLogin;
        setState(() => _errorText = error);
        return error;
      }
    } else {
      if (!Validator.isValidEmail(trimmed)) {
        final error = l10n.errInvalidEmail;
        setState(() => _errorText = error);
        return error;
      }
    }
    return null;
  }
}