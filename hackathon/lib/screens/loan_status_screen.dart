import 'package:flutter/material.dart';

class LoanStatusScreen extends StatelessWidget {
  const LoanStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Status"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Current Loan Amount", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text("ETB 5,000", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.green[800])),
                const SizedBox(height: 20),
                const Text("Approved Limit: ETB 7,500"),
                const SizedBox(height: 10),
                LinearProgressIndicator(value: 5000 / 7500, backgroundColor: Colors.grey[300], color: Colors.green),
                const SizedBox(height: 30),
                Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.orange),
                    SizedBox(width: 8),
                    Text("Loan Status: Pending Approval", style: TextStyle(fontSize: 16)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
