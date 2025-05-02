import 'package:flutter/material.dart';

class FarmerHomeScreen extends StatelessWidget {
  const FarmerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Welcome Back, Farmer!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// Top icon bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.green),
                  tooltip: 'Home',
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard');
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
                  icon: const Icon(Icons.person, color: Colors.blue),
                  tooltip: 'Profile',
                  onPressed: () {
                    Navigator.pushNamed(context, '/view-profile');
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Dashboard cards
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                DashboardCard(
                  title: "Loan Status",
                  icon: Icons.monetization_on,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pushNamed(context, '/loan');
                  },
                ),
                DashboardCard(
                  title: "Repayment Info",
                  icon: Icons.receipt_long,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.pushNamed(context, '/repayment');
                  },
                ),
                DashboardCard(
                  title: "Harvest Status",
                  icon: Icons.agriculture,
                  color: Colors.brown,
                  onTap: () {
                    Navigator.pushNamed(context, '/harvest-log');
                  },
                ),
                DashboardCard(
                  title: "Prediction Tool",
                  icon: Icons.analytics,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pushNamed(context, '/prediction');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 24,
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 4,
          color: color.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(height: 10),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
