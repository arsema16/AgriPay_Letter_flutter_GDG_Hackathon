import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
import '../providers/farmer_provider.dart';
import '../widgets/custom_button.dart';

class LoanRequestScreen extends StatefulWidget {
  @override
  _LoanRequestScreenState createState() => _LoanRequestScreenState();
}

class _LoanRequestScreenState extends State<LoanRequestScreen> {
  final _amountCtrl = TextEditingController();
  final _repaymentCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loanProvider = context.watch<LoanProvider>();
    final farmerProvider = context.watch<FarmerProvider>();
    final farmer = farmerProvider.farmer;

    // Check if farmer data is null and display a message
    if (farmer == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loan Request'),
          backgroundColor: Colors.green,
        ),
        body: Center(child: Text('No farmer data. Please register first.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Request'),
        backgroundColor: Colors.green,
      ),
      body: farmerProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loan Request for ${farmer.name}', // Assuming 'name' exists in the Farmer model
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Loan Amount',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    _buildTextFormField(
                      controller: _amountCtrl,
                      label: 'Enter Amount',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the loan amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Repayment Period (in months)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    _buildTextFormField(
                      controller: _repaymentCtrl,
                      label: 'Enter Months',
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter repayment period';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage('assets/images/loan_image.png'),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Loan for ${farmer.name}', // Assuming 'name' instead of 'crop'
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Repayment Period: ${_repaymentCtrl.text} months',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    CustomButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Validate and parse input before calling updateLoan
                          final amount = _amountCtrl.text;
                          final repayment = _repaymentCtrl.text;

                          if (amount.isEmpty || repayment.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please fill all fields')),
                            );
                            return;
                          }

                          try {
                            final parsedAmount = double.parse(amount);
                            final parsedRepayment = int.parse(repayment);

                            // Call the loanProvider.updateLoan method
                            loanProvider.updateLoan(
                              parsedAmount,
                              parsedRepayment,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Loan Requested Successfully')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid input. Please check the values')),
                            );
                          }
                        }
                      },
                      text: 'Submit Loan Request',
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        labelStyle: TextStyle(color: Colors.green),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }
}
