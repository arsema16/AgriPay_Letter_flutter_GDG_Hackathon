import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const PredictionScreen());
}

class PredictionScreen extends StatelessWidget {
  const PredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loan Calculator',
      
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green[800],
          secondary: Colors.green[200],
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.green[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.green[900]!, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.green[900]),
          prefixIconColor: Colors.green[800],
        ),
      ),
      home: const LoanCalculatorScreen(),
    );
  }
}

class LoanCalculatorScreen extends StatefulWidget {
  const LoanCalculatorScreen({super.key});

  @override
  State<LoanCalculatorScreen> createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _cropType;
  double? _landSize;
  String? _yieldHistory;
  double? _loanableAmount;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  final List<String> cropTypes = ['Rice', 'Corn', 'Wheat'];
  final List<String> yieldHistories = ['Poor', 'Average', 'Good'];

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _calculateLoan() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Base loan rates per hectare
      final Map<String, double> baseLoanRates = {
        'Rice': 1000.0,
        'Corn': 800.0,
        'Wheat': 900.0,
      };

      // Yield multipliers
      final Map<String, double> yieldMultipliers = {
        'Poor': 0.8,
        'Average': 1.0,
        'Good': 1.2,
      };

      double baseRate = baseLoanRates[_cropType!]!;
      double yieldMultiplier = yieldMultipliers[_yieldHistory!]!;
      double loanAmount = _landSize! * baseRate * yieldMultiplier;

      setState(() {
        _loanableAmount = loanAmount;
      });
    }
  }

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
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    'Agricultural Loan Calculator',
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Crop Type',
                              prefixIcon: Icon(Icons.grass),
                            ),
                            value: _cropType,
                            items: cropTypes
                                .map((crop) => DropdownMenuItem(
                                      value: crop,
                                      child: Text(crop),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _cropType = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'Please select a crop type' : null,
                            onSaved: (value) => _cropType = value,
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Land Size (hectares)',
                              prefixIcon: Icon(Icons.landscape),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter land size';
                              }
                              double? parsed = double.tryParse(value);
                              if (parsed == null || parsed <= 0) {
                                return 'Please enter a valid positive number';
                              }
                              return null;
                            },
                            onSaved: (value) => _landSize = double.parse(value!),
                          ),
                          const SizedBox(height: 16.0),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Yield History',
                              prefixIcon: Icon(Icons.trending_up),
                            ),
                            value: _yieldHistory,
                            items: yieldHistories
                                .map((yield) => DropdownMenuItem(
                                      value: yield,
                                      child: Text(yield),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _yieldHistory = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'Please select yield history' : null,
                            onSaved: (value) => _yieldHistory = value,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  GestureDetector(
                    onTapDown: (_) => _buttonAnimationController.forward(),
                    onTapUp: (_) {
                      _buttonAnimationController.reverse();
                      _calculateLoan();
                    },
                    onTapCancel: () => _buttonAnimationController.reverse(),
                    child: ScaleTransition(
                      scale: _buttonScaleAnimation,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Calculate Loanable Amount'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  if (_loanableAmount != null)
                    AnimatedOpacity(
                      opacity: _loanableAmount != null ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Card(
                        elevation: 4,
                        color: Colors.green[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Estimated Loanable Amount\n\$${(_loanableAmount!).toStringAsFixed(2)}',
                            style: GoogleFonts.roboto(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}