import 'package:flutter/material.dart';
void showAddOtherOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      width: double.infinity, 
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            _buildOptionTile(context, Icons.camera_alt, "Camera", Colors.blue, () {}),
            _buildOptionTile(context, Icons.photo_library, "Album", Colors.purple, () {}),
            _buildOptionTile(context, Icons.location_on, "Location", Colors.red, () {}),
            _buildOptionTile(context, Icons.insert_drive_file, "Files", Colors.orange, () {}),
            const SizedBox(height: 10), 
          ],
        ),
      ),
    ),
  );
}

Widget _buildOptionTile(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: color.withValues(alpha:235 ),
      child: Icon(icon, color: color),
    ),
    title: Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    onTap: () {
      Navigator.pop(context);
      onTap();
    },
  );
}