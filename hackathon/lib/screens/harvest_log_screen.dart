import 'package:flutter/material.dart';

class HarvestStatusScreen extends StatelessWidget {
  const HarvestStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Harvest Status"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Latest Harvests", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...List.generate(3, (index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.agriculture),
                  title: Text("Wheat"),
                  subtitle: Text("Quantity: 250 kg\nDate: April 15, 2025"),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            }),
            const SizedBox(height: 20),
            const Text("Sync Status: All logs synced", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
