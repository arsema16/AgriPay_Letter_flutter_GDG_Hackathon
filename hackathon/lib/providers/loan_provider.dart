import 'package:flutter/material.dart';
import '/models/farmer.dart';
class LoanProvider with ChangeNotifier {
  double? _loanAmount;
  int? _repaymentPeriod;

  double? get loanAmount => _loanAmount;
  int? get repaymentPeriod => _repaymentPeriod;
   Farmer? _farmer;

  void updateFarmer(Farmer farmer) {
    _farmer = farmer;
    notifyListeners();
  }
    Farmer? get farmer => _farmer;

  // Method to update loan details
  void updateLoan(double amount, int repaymentPeriod) {
    _loanAmount = amount;
    _repaymentPeriod = repaymentPeriod;
    notifyListeners();  // Notify listeners for any changes
  }

  // You can add more methods to fetch loan data from an API or local database if needed
}
