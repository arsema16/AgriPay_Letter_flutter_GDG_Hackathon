import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HarvestLog {
  final String crop;
  final int quantity;
  final String date;

  HarvestLog({
    required this.crop,
    required this.quantity,
    required this.date,
  });
}

class YieldHistoryScreen extends StatelessWidget {
  final List<HarvestLog> logs = [
    HarvestLog(crop: 'Maize', quantity: 500, date: '2024-11-01'),
    HarvestLog(crop: 'Wheat', quantity: 300, date: '2025-01-15'),
    HarvestLog(crop: 'Rice', quantity: 400, date: '2025-03-20'),
    HarvestLog(crop: 'Maize', quantity: 600, date: '2025-04-10'),
    HarvestLog(crop: 'Wheat', quantity: 350, date: '2025-04-25'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Yield History')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Harvest Insight',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 200, child: _buildChart()),
              SizedBox(height: 16),
              Expanded(child: _buildLogList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogList() {
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Card(
          child: ListTile(
            leading: Icon(Icons.agriculture),
            title: Text(log.crop),
            subtitle: Text('Date: ${log.date}'),
            trailing: Text('${log.quantity} kg'),
          ),
        );
      },
    );
  }

  Widget _buildChart() {
    // Aggregate by crop
    final Map<String, int> cropTotals = {};
    for (var log in logs) {
      cropTotals[log.crop] = (cropTotals[log.crop] ?? 0) + log.quantity;
    }

    final crops = cropTotals.keys.toList();
    final barGroups = List.generate(crops.length, (i) {
      final crop = crops[i];
      return BarChartGroupData(x: i, barRods: [
        BarChartRodData(
          fromY: 0, // Starting point of the bar (bottom)
          toY: cropTotals[crop]!.toDouble(), // Ending point of the bar (top)
          color: Colors.blue,
          width: 18,
        ),
      ]);
    });

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            axisNameWidget: Text('Quantity (kg)'),
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: Text('Crops'),
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < crops.length) {
                  return Text(crops[index]); // Get crop name for X-axis labels
                }
                return Text(''); // Return empty text if index is out of bounds
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
