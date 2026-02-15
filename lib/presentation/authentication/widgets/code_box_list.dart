import 'package:flutter/material.dart';
import 'code_box.dart';
import 'package:auth/common/functions/code_box_handlers.dart';

class CodeBoxList extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final VoidCallback? onComplete;
  final bool enabled;
  final int length;
  final bool isForVerification;

  const CodeBoxList({
    super.key,
    required this.controllers,
    required this.focusNodes,
    this.onComplete,
    this.enabled = true,
    this.length = 6,
    required this.isForVerification,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final availableWidth = screenWidth - (horizontalPadding * 2.5);
    final spacing = availableWidth > 400 ? 8.0 : (availableWidth > 320 ? 6.0 : 4.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(length, (index) {
                // --- LOGIC: Disable box if the previous one is empty ---
                bool isBoxActive = true;
                if (index > 0) {
                  // Enable this box only if the previous controller has text
                  isBoxActive = controllers[index - 1].text.isNotEmpty;
                }

                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: spacing),
                    child: CodeBox(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      // Combined check: overall enabled state AND box-specific sequence
                      enabled: enabled && isBoxActive, 
                      onChanged: (value) => CodeBoxHandlers.onCodeChanged(
                        value,
                        index,
                        focusNodes,
                        controllers,
                        context,
                        onComplete,
                        isForVerification,
                      ),
                      onKeyEvent: (event) => CodeBoxHandlers.onKeyEvent(
                        event,
                        index,
                        controllers,
                        focusNodes,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}