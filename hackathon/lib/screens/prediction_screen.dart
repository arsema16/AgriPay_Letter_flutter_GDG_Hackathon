import 'package:flutter/material.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  String? selectedCrop;
  final TextEditingController harvestController = TextEditingController();
  String? predictionResult;

  final List<String> crops = ['Wheat', 'Maize', 'Teff', 'Barley', 'Sorghum'];

  void _predictLoan() {
    // Placeholder logic (replace with real backend logic later)
    double harvest = double.tryParse(harvestController.text) ?? 0;
    if (harvest > 0 && selectedCrop != null) {
      double loanAmount = harvest * 15.0; // mock multiplier
      setState(() {
        predictionResult = "Estimated Loan: ETB ${loanAmount.toStringAsFixed(2)}";
      });
    } else {
      setState(() {
        predictionResult = "Please enter valid data.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction Tool"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Crop Type", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedCrop,
              hint: const Text("Choose crop"),
              isExpanded: true,
              items: crops.map((crop) {
                return DropdownMenuItem(value: crop, child: Text(crop));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCrop = value;
                });
              },
            ),
            const SizedBox(height: 16),

            const Text("Expected Harvest (in quintals)", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: harvestController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "e.g. 20",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _predictLoan,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Predict Loan"),
              ),
            ),

            const SizedBox(height: 20),
            if (predictionResult != null)
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    predictionResult!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
