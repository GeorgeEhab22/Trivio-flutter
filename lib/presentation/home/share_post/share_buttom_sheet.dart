import 'package:flutter/material.dart';
import '../../../common/basic_app_button.dart';
import '../../authentication/widgets/show_custom_snackbar.dart';

class ShareBottomSheet extends StatefulWidget {
  final VoidCallback onShare;

  const ShareBottomSheet({super.key, required this.onShare});

  @override
  State<ShareBottomSheet> createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends State<ShareBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  bool get _canPost => _controller.text.trim().isNotEmpty;

  void _onSharePressed() {
    final content = _controller.text.trim();
    if (content.isEmpty) {
      showCustomSnackBar(context, "Write something first!", false);
      return;
    }

    Navigator.pop(context);

    // call cubit here later
    widget.onShare(); // updates UI counters in PostStats
    showCustomSnackBar(context, "Post shared successfully!", true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
                    "User Name", // 🧍‍♂️ temporary placeholder
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
                onChanged: (_) => setState(() {}),
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

              // // 🔹 Section 1: Send in Messenger
              // const Text(
              //   "Send in Messenger",
              //   style: TextStyle(
              //     fontSize: 15,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // const SizedBox(height: 12),
              // SizedBox(
              //   height: 90,
              //   child: ListView.separated(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: 6, // Placeholder count
              //     separatorBuilder: (_, __) => const SizedBox(width: 12),
              //     itemBuilder: (context, index) {
              //       return Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           GestureDetector(
              //             onTap: () {
              //               //to do: implement "send to friend" later
              //               showCustomSnackBar(
              //                 context,
              //                 "Message sent to Friend ${index + 1}",
              //                 true,
              //               );
              //             },
              //             child: CircleAvatar(
              //               radius: 30,
              //               backgroundColor: Colors.grey[300],
              //               child: const Icon(Icons.person, color: Colors.grey),
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           const Text(
              //             "Friend",
              //             style: TextStyle(
              //               fontSize: 12,
              //               color: Colors.black87,
              //             ),
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // ),

              // const SizedBox(height: 24),

              // // 🔹 Section 2: Share To
              // const Text(
              //   "Share to",
              //   style: TextStyle(
              //     fontSize: 15,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // const SizedBox(height: 12),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     _shareOption(FontAwesomeIcons.whatsapp, "WhatsApp", Colors.green),
              //     _shareOption(FontAwesomeIcons.instagram, "Instagram", Colors.purple),
              //     _shareOption(Icons.link, "Copy Link", Colors.blueGrey),
              //     _shareOption(Icons.more_horiz, "More", Colors.black54),
              //   ],
              // ),

              // const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // 🔸 Share option widget (reusable)
  // Widget _shareOption(IconData icon, String label, Color color) {
  //   return GestureDetector(
  //     onTap: () {
  //       // to do: integrate share logic later (use case)
  //       showCustomSnackBar(context, "Shared via $label", true);
  //     },
  //     child: Column(
  //       children: [
  //         CircleAvatar(
  //           radius: 24,
  //           backgroundColor: color,
  //           child: Icon(icon, color: color, size: 22),
  //         ),
  //         const SizedBox(height: 5),
  //         Text(label, style: const TextStyle(fontSize: 12)),
  //       ],
  //     ),
  //   );
  // }
}
