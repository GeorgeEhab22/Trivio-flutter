import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import '../../../common/basic_app_button.dart';

class ShareBottomSheet extends StatefulWidget {
  // final VoidCallback onShare;

  const ShareBottomSheet({super.key, });

  @override
  State<ShareBottomSheet> createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends State<ShareBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  bool get _canPost => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    // listen to controller so we react to programmatic changes as well
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (!mounted) return;
    // calling setState only when needed reduces rebuild churn
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSharePressed() {
    final content = _controller.text.trim();
    if (content.isEmpty) {
      showCustomSnackBar(context, "Write something first!", false);
      return;
    }

    // First call the share callback so parent updates its state/servers.

    // Provide immediate feedback while the sheet is still mounted.
    showCustomSnackBar(context, "Post shared successfully!", true);

    // Clear the input and close the sheet
    _controller.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Use AnimatedPadding to follow the keyboard (keeps your original behavior)
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Drag Handle
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // 🔹 Header: User info + Share button
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "User Name", // temporary placeholder
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    BasicAppButton(
                      onPressed: _canPost ? _onSharePressed : null,
                      title: "Share",
                      height: 36,
                      width: 90,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 🔹 Text Field
                TextField(
                  controller: _controller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Say something about this post...",
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
