import 'package:flutter/material.dart';
import '/screens/loan_status_screen.dart';

enum LoanStatus { requested, approved, rejected, pending }

class LoanRequestScreen extends StatefulWidget {
  final String itemName;
  final double maxLoanAmount;

  const LoanRequestScreen({
    Key? key,
    required this.itemName,
    required this.maxLoanAmount,
  }) : super(key: key);

  @override
  _LoanRequestScreenState createState() => _LoanRequestScreenState();
}

class _LoanRequestScreenState extends State<LoanRequestScreen> {
  LoanStatus _status = LoanStatus.pending;
  final TextEditingController _amountController = TextEditingController();
  bool _isSubmitting = false;

  String _itemType = 'Fertilizer'; // Default value is 'Fertilizer'
  String? _selectedType;

  // List of types for fertilizer and seed
  final Map<String, List<String>> _types = {
    'Fertilizer': ['Nitrogen', 'Phosphorus', 'Potassium'],
    'Seed': ['Corn', 'Wheat', 'Rice'],
  };

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.maxLoanAmount.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submitLoanApplication() async {
    setState(() {
      _isSubmitting = true;
      _status = LoanStatus.requested;
    });

    await Future.delayed(const Duration(seconds: 2));

    // Simulated backend logic – replace this with actual HTTP call
    final isApproved = DateTime.now().millisecond % 2 == 0;
    setState(() {
      _status = isApproved ? LoanStatus.approved : LoanStatus.rejected;
      _isSubmitting = false;
    });

    if (_status == LoanStatus.approved) {
      await Future.delayed(const Duration(seconds: 1));
      double loanAmount = double.tryParse(_amountController.text) ?? 0;
      final dueDate = DateTime.now().add(Duration(days: 30));
      final dueDateFormatted =
          "${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}";

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoanStatusScreen(
            approvedLimit: widget.maxLoanAmount,
            currentLoan: loanAmount,
            repaymentDue: loanAmount,
            repaymentDate: dueDateFormatted,
          ),
        ),
      );
    }
  }

  Color _getStatusColor() {
    switch (_status) {
      case LoanStatus.requested:
        return Colors.orange;
      case LoanStatus.approved:
        return Colors.green;
      case LoanStatus.rejected:
        return Colors.red;
      case LoanStatus.pending:
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (_status) {
      case LoanStatus.requested:
        return "Requested";
      case LoanStatus.approved:
        return "Approved";
      case LoanStatus.rejected:
        return "Rejected";
      case LoanStatus.pending:
      default:
        return "Pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_itemType} Loan Application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Option to choose between Seed or Fertilizer
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Fertilizer'),
                    value: 'Fertilizer',
                    groupValue: _itemType,
                    onChanged: (value) {
                      setState(() {
                        _itemType = value!;
                        _selectedType = null; // Reset type selection
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Seed'),
                    value: 'Seed',
                    groupValue: _itemType,
                    onChanged: (value) {
                      setState(() {
                        _itemType = value!;
                        _selectedType = null; // Reset type selection
                      });
                    },
                  ),
                ),
              ],
            ),
            // Dropdown or list to select the type of Fertilizer or Seed
            if (_itemType != null)
              Column(
                children: [
                  DropdownButton<String>(
                    hint: Text('Select ${_itemType} Type'),
                    value: _selectedType,
                    items: _types[_itemType]!
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
            SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item: ${widget.itemName}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Maximum Loan Amount: \$${widget.maxLoanAmount.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Loan Amount',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.money),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _getStatusColor()),
                          ),
                          child: Text(
                            _getStatusText(),
                            style: TextStyle(
                              color: _getStatusColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _isSubmitting || _status == LoanStatus.approved
                              ? null
                              : _submitLoanApplication,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: _isSubmitting
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text('Submit Application'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_status == LoanStatus.approved)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Your loan has been approved! Funds will be disbursed shortly.',
                    style: TextStyle(color: Colors.green.shade800),
                  ),
                ),
              ),
            if (_status == LoanStatus.rejected)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Sorry, your loan request was rejected. Try again later.',
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
