import 'package:flutter/material.dart';

class LoanStatusScreen extends StatefulWidget {
  final double approvedLimit;
  final double currentLoan;
  final double repaymentDue;
  final String repaymentDate;

  const LoanStatusScreen({
    Key? key,
    required this.approvedLimit,
    required this.currentLoan,
    required this.repaymentDue,
    required this.repaymentDate,
  }) : super(key: key);

  @override
  _LoanStatusScreenState createState() => _LoanStatusScreenState();
}

class _LoanStatusScreenState extends State<LoanStatusScreen> {
  String _selectedOption = 'Fertilizer'; // Default selection

  final Map<String, List<String>> _types = {
    'Fertilizer': ['Nitrogen', 'Phosphorus', 'Potassium'],
    'Seed': ['Corn', 'Wheat', 'Rice'],
  };

  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    double usagePercent = widget.approvedLimit > 0 ? widget.currentLoan / widget.approvedLimit : 0.0;
    bool isRepaymentDue = widget.repaymentDue > 0;

    return Scaffold(
      appBar: AppBar(title: Text('Loan Status')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLoanCard('Approved Limit', '\$${widget.approvedLimit.toStringAsFixed(2)}', Colors.blue),
            _buildLoanCard('Current Loan', '\$${widget.currentLoan.toStringAsFixed(2)}', Colors.orange),
            _buildLoanCard(
              'Repayment Due',
              isRepaymentDue ? '\$${widget.repaymentDue.toStringAsFixed(2)}' : 'None',
              isRepaymentDue ? Colors.red : Colors.green,
            ),
            if (isRepaymentDue)
              _buildLoanCard('Due Date', widget.repaymentDate, Colors.purple),
            SizedBox(height: 30),
            Text('Loan Usage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: usagePercent,
              minHeight: 12,
              backgroundColor: Colors.grey.shade300,
              color: usagePercent < 0.7
                  ? Colors.green
                  : usagePercent < 1.0
                      ? Colors.orange
                      : Colors.red,
            ),
            SizedBox(height: 8),
            Text('${(usagePercent * 100).toStringAsFixed(1)}% used'),
            SizedBox(height: 20),
            // Fertilizer or Seed selection
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Fertilizer'),
                    value: 'Fertilizer',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                        _selectedType = null; // Reset type selection
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Seed'),
                    value: 'Seed',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                        _selectedType = null; // Reset type selection
                      });
                    },
                  ),
                ),
              ],
            ),
            // Dropdown to select specific type of Fertilizer or Seed
            if (_selectedOption != null)
              Column(
                children: [
                  DropdownButton<String>(
                    hint: Text('Select ${_selectedOption} Type'),
                    value: _selectedType,
                    items: _types[_selectedOption]!
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  if (_selectedType != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        'You selected: $_selectedType',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanCard(String title, String value, Color color) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: ListTile(
        leading: Icon(Icons.account_balance_wallet, color: color),
        title: Text(title),
        trailing: Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
