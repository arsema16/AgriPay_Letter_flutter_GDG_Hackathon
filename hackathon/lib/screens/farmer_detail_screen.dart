import 'package:flutter/material.dart';
import '../models/farmer_model.dart';

class FarmerDetailsScreen extends StatelessWidget {
  final Farmer farmer;

  const FarmerDetailsScreen({Key? key, required this.farmer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Farmer Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                title: Text(farmer.name),
                subtitle: Text('ID: ${farmer.id}'),
                trailing: Chip(
                  label: Text(farmer.loanStatus),
                  backgroundColor: Colors.blue.shade100,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('🌾 Harvest Logs', style: Theme.of(context).textTheme.titleLarge),
            ...[
              ListTile(title: Text('Maize - 500kg'), subtitle: Text('Date: 2024-10-15')),
              ListTile(title: Text('Wheat - 300kg'), subtitle: Text('Date: 2024-08-10')),
            ],
            Divider(),

            Text('💰 Repayment History', style: Theme.of(context).textTheme.titleLarge),
            ...[
              ListTile(title: Text('Amount: 2000 ETB'), subtitle: Text('Date: 2024-12-01')),
              ListTile(title: Text('Amount: 1500 ETB'), subtitle: Text('Date: 2024-09-05')),
            ],
            Divider(),

            Text('📄 Loan Requests', style: Theme.of(context).textTheme.titleLarge),
            ...[
              ListTile(title: Text('Request: 5000 ETB'), subtitle: Text('Status: Approved')),
              ListTile(title: Text('Request: 3000 ETB'), subtitle: Text('Status: Pending')),
            ],
          ],
        ),
      ),
    );
  }
}
