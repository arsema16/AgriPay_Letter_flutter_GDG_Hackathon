import 'package:flutter/material.dart';

class RepaymentDashboardScreen extends StatefulWidget {
  final double? loanAmount;
  final String? itemName;

  const RepaymentDashboardScreen({
    Key? key,
    this.loanAmount,
    this.itemName,
  }) : super(key: key);

  @override
  _RepaymentDashboardScreenState createState() => _RepaymentDashboardScreenState();
}

class _RepaymentDashboardScreenState extends State<RepaymentDashboardScreen> {
  late double totalOwed;
  String status = "Due Soon"; // Possible: Paid, Due Soon, Overdue

  @override
  void initState() {
    super.initState();
    // Use the passed loan amount or default to 0.0
    totalOwed = widget.loanAmount ?? 0.0;

    // If the amount is 0, set status to indicate no active loans
    if (totalOwed == 0.0) {
      status = "No Active Loans";
    } else {
      // Simulate a simple due date for loan repayment
      // If the amount is greater than 100, mark as "Overdue"
      if (totalOwed > 100) {
        status = "Overdue";
      } else {
        status = "Due Soon";
      }
    }
  }

  void _simulatePayment() {
    setState(() {
      totalOwed = 0.0;
      status = "Paid";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Repayment marked as paid.')),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case "Paid":
        return Colors.green;
      case "Due Soon":
        return Colors.orange;
      case "Overdue":
        return Colors.red;
      case "No Active Loans":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case "Paid":
        return Icons.check_circle;
      case "Due Soon":
        return Icons.schedule;
      case "Overdue":
        return Icons.warning;
      case "No Active Loans":
        return Icons.info_outline;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Repayment Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSummaryCard(),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: (status != "Paid" && totalOwed > 0)
                  ? _simulatePayment
                  : null,
              icon: Icon(Icons.payment),
              label: Text('Mark as Paid (Demo)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: (status != "Paid" && totalOwed > 0)
                    ? Colors.blue
                    : Colors.grey,
                disabledBackgroundColor: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    String loanItemText =
        widget.itemName != null ? 'Loan for ${widget.itemName}' : 'Total Owed';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              _getStatusIcon(),
              size: 40,
              color: _getStatusColor(),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loanItemText,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '\$${totalOwed.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Status: $status',
                  style: TextStyle(
                    fontSize: 16,
                    color: _getStatusColor(),
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
