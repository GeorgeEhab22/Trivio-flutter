import 'package:flutter/material.dart';

class SendButton extends StatefulWidget {
  final VoidCallback onSend;
  final TextEditingController controller;

  const SendButton({super.key, required this.onSend, required this.controller});

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Send message',
      button: true,
      child: AnimatedOpacity(
        opacity: _hasText ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: _hasText ? widget.onSend : null,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF00E639),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _hasText
                  ? [
                      BoxShadow(
                        color: const Color(0xFF00E639).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: const Icon(
              Icons.arrow_upward_rounded,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}