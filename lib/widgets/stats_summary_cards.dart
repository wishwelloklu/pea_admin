import 'package:flutter/material.dart';
import 'package:prayer_palace_admin/core/func/app_colors.dart';

class StatsSummaryCards extends StatelessWidget {
  final int data;
  final String label;

  const StatsSummaryCards({super.key, required this.data, required this.label});

  @override
  Widget build(BuildContext context) {
    return _buildCard(label, data, Color(0xFF420f8d));
  }

  Widget _buildCard(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor.withValues(alpha: .3), width: 2),
        borderRadius: BorderRadius.circular(10),
        color: primaryColor,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [primaryColor, primaryColor.withValues(alpha: .7)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
