import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farmer_provider.dart'; // Make sure this path is correct
void main() {
  runApp(const FarmerHomeScreen());
}

class FarmerHomeScreen extends StatelessWidget {
  const FarmerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmer = Provider.of<FarmerProvider>(context).farmer;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/registration_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Optional overlay for contrast
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  "Welcome Back, ${farmer?.name ?? 'Farmer'}!",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

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
                        Navigator.pushNamed(context, '/notification');
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

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    DashboardCard(
                      title: "Loan Request",
                      icon: Icons.account_balance,
                      color: Colors.amber,
                      onTap: () {
                        Navigator.pushNamed(context, '/loan-request');
                      },
                    ),
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
                      title: "Yield History",
                      icon: Icons.bar_chart,
                      color: Colors.green,
                      onTap: () {
                        Navigator.pushNamed(context, '/yield');
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
        ],
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
          color: color.withOpacity(0.8), // Less transparent
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
