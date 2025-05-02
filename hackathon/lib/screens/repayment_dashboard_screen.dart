import 'package:flutter/material.dart';

class RepaymentInfoScreen extends StatelessWidget {
  const RepaymentInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Repayment Info"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    Text("Total Amount Owed", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text("ETB 3,200", style: TextStyle(fontSize: 28, color: Colors.red)),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.schedule, color: Colors.orange),
                        SizedBox(width: 8),
                        Text("Next Payment Due: May 10, 2025"),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.payment),
              label: const Text("Mark as Paid (Demo)"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            )
          ],
        ),
      ),
    );
  }
}
