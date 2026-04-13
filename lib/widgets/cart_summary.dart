import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  final double totalCost;
  final double tax;
  final double overallTotal;

  const CartSummary({
    super.key,
    required this.totalCost,
    required this.tax,
    required this.overallTotal,
  });

  String formatCurrency(double value) {
    String parts = value.toStringAsFixed(2);
    List<String> split = parts.split('.');
    String integerPart = split[0];
    String decimalPart = split[1];

    RegExp reg = RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))");
    String formattedInteger = integerPart.replaceAllMapped(reg, (Match m) => "${m[1]},");

    return "\$$formattedInteger.$decimalPart";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Cost:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                formatCurrency(totalCost),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tax (8.875%):',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                formatCurrency(tax),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Total:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                formatCurrency(overallTotal),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}