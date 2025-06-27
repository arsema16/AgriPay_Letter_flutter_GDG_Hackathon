import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Mock data for metrics
  final int totalFarmers = 150;
  final int activeLoans = 75;
  final int repaymentsDue = 20;

  // Mock data for charts
  final List<double> loanDisbursed = [5000, 7000, 6000, 8000, 9000, 10000]; // Last 6 months ($)
  final List<double> avgRepaymentTime = [4.5, 4.2, 4.8, 4.0, 3.8, 4.1]; // Last 6 months (months)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[600]!, Colors.green[100]!],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Text(
                  'Admin Dashboard',
                  style: GoogleFonts.roboto(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24.0),
                // Metrics Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetricCard('Total Farmers', totalFarmers.toString(), Icons.person),
                    _buildMetricCard('Active Loans', activeLoans.toString(), Icons.account_balance),
                    _buildMetricCard('Repayments Due', repaymentsDue.toString(), Icons.payment),
                  ],
                ),
                const SizedBox(height: 24.0),
                // Loan Disbursed Chart
                _buildChartCard(
                  title: 'Loan Disbursed (Last 6 Months)',
                  child: SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 12000,
                        barGroups: List.generate(
                          loanDisbursed.length,
                          (index) => BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: loanDisbursed[index],
                                color: Colors.green[800],
                                width: 15,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                                return Text(
                                  months[value.toInt()],
                                  style: GoogleFonts.roboto(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '\$${value.toInt()}',
                                  style: GoogleFonts.roboto(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                // Average Repayment Time Chart
                _buildChartCard(
                  title: 'Average Repayment Time (Last 6 Months)',
                  child: SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              avgRepaymentTime.length,
                              (index) => FlSpot(index.toDouble(), avgRepaymentTime[index]),
                            ),
                            isCurved: true,
                            color: Colors.green[800],
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.green[200]!.withOpacity(0.3),
                            ),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                                return Text(
                                  months[value.toInt()],
                                  style: GoogleFonts.roboto(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toStringAsFixed(1)} mo',
                                  style: GoogleFonts.roboto(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                        ),
                        borderData: FlBorderData(show: false),
                        minY: 0,
                        maxY: 6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Expanded(
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(icon, color: Colors.green[800], size: 30),
                const SizedBox(height: 8.0),
                Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.grey[800],
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

  Widget _buildChartCard({required String title, required Widget child}) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              const SizedBox(height: 16.0),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
