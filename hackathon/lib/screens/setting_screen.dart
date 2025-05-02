import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farmer_provider.dart';
import 'dart:io';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmer = Provider.of<FarmerProvider>(context).farmer;

    if (farmer == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Extract the first letter of the farmer's name to display in the avatar
    String firstLetter = farmer.name.isNotEmpty ? farmer.name[0].toUpperCase() : '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () {
                      // Pop the current screen and go back to the previous screen
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Settings",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Account Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Material(
                color: const Color(0xFFF9F7F7),
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30, // Customize the size of the avatar
                    backgroundColor: Colors.green, // Customize color as needed
                    child: Text(
                      firstLetter, // Display first letter of the name
                      style: const TextStyle(
                        fontSize: 30, // Customize the size of the letter
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(farmer.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(farmer.phone,
                      style: const TextStyle(color: Colors.grey)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to profile or any other relevant screen
                  },
                ),
              ),
            ),

            const Divider(thickness: 1),

            // Settings List
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Setting",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 8),
            _buildSettingTile(Icons.notifications, "Notification", () {}),
            _buildSettingTile(Icons.language, "Language", () {
              // Optional: show language options
            }, trailingText: "English"),
            _buildSettingTile(Icons.privacy_tip, "Privacy", () {}),
            _buildSettingTile(Icons.headset_mic, "Help Center", () {}),
            _buildSettingTile(Icons.info_outline, "About us", () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    String? trailingText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Material(
        color: const Color(0xFFF9F7F7),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: Icon(icon, color: Colors.black87),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: trailingText != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(trailingText, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right),
                  ],
                )
              : const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
