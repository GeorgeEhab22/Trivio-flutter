import 'package:auth/core/vanishing_item.dart';
import 'package:auth/core/vanishing_item_controller.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController? originalController;
  final bool isPasswordVisible;
  final VoidCallback onVisibilityToggle;
  final VoidCallback onSubmit;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final bool showValidation;
  final bool isLogin;
  final bool isConfirm;

  const PasswordField({
    super.key,
    required this.controller,
    required this.isPasswordVisible,
    required this.onVisibilityToggle,
    required this.onSubmit,
    this.originalController,
    this.label = 'Password',
    this.hint = 'password',
    this.validator,
    this.showValidation = true,
    this.isLogin = false,
    this.isConfirm = false,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final passwordRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).+$');

  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;
  bool hasTouched = false;
  bool passwordsMatch = false;
  bool showRequiredMessage = false;

  String? _errorText; 

  late final VanishingItemController<String> _vanishingController;

  @override
  void initState() {
    super.initState();
    _vanishingController = VanishingItemController<String>();
    _vanishingController.addListener(_onVanishingChanged);
    widget.controller.addListener(_onPasswordChanged);

    if (widget.isConfirm && widget.originalController != null) {
      widget.originalController!.addListener(_checkPasswordMatch);
      widget.controller.addListener(_checkPasswordMatch);
      _vanishingController.hideImmediately('passwordMatch');
    }

    _vanishingController.hideImmediately('required');
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPasswordChanged);
    if (widget.isConfirm && widget.originalController != null) {
      widget.originalController!.removeListener(_checkPasswordMatch);
      widget.controller.removeListener(_checkPasswordMatch);
    }
    _vanishingController.removeListener(_onVanishingChanged);
    _vanishingController.dispose();
    super.dispose();
  }

  void _onVanishingChanged() => setState(() {});

  void _onPasswordChanged() {
    final password = widget.controller.text;

    if (password.isNotEmpty) {
      hasTouched = true;
      if (showRequiredMessage || _errorText != null) {
        _vanishingController.hideImmediately('required');
        setState(() {
          showRequiredMessage = false;
          _errorText = null; 
        });
      }
    } else {
      if (!showRequiredMessage) {
        _vanishingController.show('required');
        setState(() {
          showRequiredMessage = true;
        });
      }
    }

    if (widget.isLogin || widget.isConfirm) return;

    bool shouldRebuild = false;
    final checks = {
      'minLength': password.length >= 8,
      'uppercase': password.contains(RegExp(r'[A-Z]')),
      'lowercase': password.contains(RegExp(r'[a-z]')),
      'number': password.contains(RegExp(r'\d')),
      'specialChar': password.contains(RegExp(r'[!@#\$&*~]')),
    };

    for (final entry in checks.entries) {
      final key = entry.key;
      final value = entry.value;
      final oldValue = _getRequirementState(key);

      if (oldValue != value) {
        shouldRebuild = true;
        _setRequirementState(key, value);

        if (value) {
          _vanishingController.scheduleHide(key);
        } else {
          _vanishingController.show(key);
        }
      }
    }

    if (shouldRebuild) setState(() {});
  }

  void _checkPasswordMatch() {
    if (!widget.isConfirm || widget.originalController == null) return;

    final confirm = widget.controller.text.trim();
    final original = widget.originalController!.text.trim();

    if (confirm.isEmpty) {
      if (!_vanishingController.isHidden('passwordMatch')) {
        _vanishingController.hideImmediately('passwordMatch');
      }

      if (passwordsMatch) {
        setState(() => passwordsMatch = false);
      }

      return;
    }

    final match = confirm == original;

    if (passwordsMatch != match) {
      setState(() => passwordsMatch = match);

      if (match) {
        _vanishingController.scheduleHide('passwordMatch');
      } else {
        _vanishingController.show('passwordMatch');
      }
    } else {
      if (!match) _vanishingController.show('passwordMatch');
    }
  }

  bool _getRequirementState(String key) {
    switch (key) {
      case 'minLength':
        return hasMinLength;
      case 'uppercase':
        return hasUppercase;
      case 'lowercase':
        return hasLowercase;
      case 'number':
        return hasNumber;
      case 'specialChar':
        return hasSpecialChar;
      default:
        return false;
    }
  }

  void _setRequirementState(String key, bool value) {
    switch (key) {
      case 'minLength':
        hasMinLength = value;
        break;
      case 'uppercase':
        hasUppercase = value;
        break;
      case 'lowercase':
        hasLowercase = value;
        break;
      case 'number':
        hasNumber = value;
        break;
      case 'specialChar':
        hasSpecialChar = value;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showRequirements = widget.showValidation &&
        !widget.isLogin &&
        !widget.isConfirm &&
        (hasTouched || widget.controller.text.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: !widget.isPasswordVisible,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            FocusScope.of(context).unfocus();
            widget.onSubmit();
          },
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            errorText: _errorText,
            suffixIcon: IconButton(
              icon: Icon(
                widget.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: widget.onVisibilityToggle,
            ),
          ).applyDefaults(theme.inputDecorationTheme),
          validator: (value) {
            final trimmed = value?.trim() ?? '';
            if (trimmed.isEmpty) {
              setState(() {
                _errorText = widget.isConfirm
                    ? 'Please confirm your password'
                    : 'Password is required';
                showRequiredMessage = true;
              });
              return _errorText;
            }
            return null;
          },
        ),

       
        if (widget.isConfirm && widget.originalController != null) ...[
          const SizedBox(height: 8),
          VanishingItem(
            isVisible: !_vanishingController.isHidden('passwordMatch'),
            child: _buildRequirement(
              passwordsMatch
                  ? 'Passwords match'
                  : 'Passwords do not match',
              passwordsMatch,
            ),
          ),
        ],

        if (showRequirements) ...[
          const SizedBox(height: 8),
          VanishingItem(
            isVisible: !_vanishingController.isHidden('minLength'),
            child: _buildRequirement('At least 8 characters', hasMinLength),
          ),
          VanishingItem(
            isVisible: !_vanishingController.isHidden('uppercase'),
            child: _buildRequirement('One uppercase letter', hasUppercase),
          ),
          VanishingItem(
            isVisible: !_vanishingController.isHidden('lowercase'),
            child: _buildRequirement('One lowercase letter', hasLowercase),
          ),
          VanishingItem(
            isVisible: !_vanishingController.isHidden('number'),
            child: _buildRequirement('One number', hasNumber),
          ),
          VanishingItem(
            isVisible: !_vanishingController.isHidden('specialChar'),
            child: _buildRequirement(
              'One special character (!@#\$&*~)',
              hasSpecialChar,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
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
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
