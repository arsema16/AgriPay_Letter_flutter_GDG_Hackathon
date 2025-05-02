import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farmer_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // CircleAvatar now displaying the first letter of the name
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green, // Customize color as needed
              child: Text(
                firstLetter,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoTile("Name", farmer.name),
            _buildInfoTile("Phone", farmer.phone),
            _buildInfoTile("Email", farmer.email ?? "N/A"),
            _buildInfoTile("ID Number", farmer.idNumber ?? "N/A"),
            _buildInfoTile("Role", farmer.role),
            if (farmer.role == 'farmer') ...[
              _buildInfoTile("Land Size", "${farmer.landSize ?? 'N/A'} ha"),
              _buildInfoTile("Crop Type", farmer.cropType ?? 'N/A'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}
