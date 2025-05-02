import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farmer_provider.dart';
import '../screens/setting_screen.dart';
import '../screens/profile_screen.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmer = Provider.of<FarmerProvider>(context).farmer;

    if (farmer == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    String firstLetter = farmer.name.isNotEmpty ? farmer.name[0].toUpperCase() : '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Top icon bar for navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.black87),
                  tooltip: 'Home',
                  onPressed: () {
                    Navigator.pushNamed(context, '/farmer');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                  tooltip: 'Calendar',
                  onPressed: () {
                    Navigator.pushNamed(context, '/calendar');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.red),
                  tooltip: 'Notifications',
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.green),
                  tooltip: 'Profile',
                  onPressed: () {
                    Navigator.pushNamed(context, '/view-profile');
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Profile Avatar and Info
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: Text(
                  firstLetter,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              farmer.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              farmer.phone,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Menu Options
            _buildMenuTile(Icons.person, "Profile", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }),
            _buildMenuTile(Icons.settings, "Setting", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            }),
            _buildMenuTile(Icons.mail, "Contact", () {}),
            _buildMenuTile(Icons.share, "Share App", () {}),
            _buildMenuTile(Icons.help, "Help", () {}),
            const Spacer(),

            // Sign out button
            TextButton(
              onPressed: () {
                // Add your sign-out logic here
              },
              child: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.deepOrange, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        onTap: (index) {
          // Handle tab switching if needed
        },
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Material(
        color: const Color(0xFFF9F7F7),
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          leading: Icon(icon, color: Colors.black87),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
