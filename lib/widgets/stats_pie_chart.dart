import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prayer_palace_admin/core/func/app_colors.dart';

class StatsPieChart extends StatelessWidget {
  final Map<String, dynamic> data;
  final String title;
  final List<Color> colors;

  const StatsPieChart({
    super.key,
    required this.data,
    required this.title,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final chartData = Map.of(data)..remove("total");
    final entries = chartData.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: primaryColor.withValues(alpha: .3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),

          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: List.generate(entries.length, (i) {
                      final value = entries[i].value.toDouble();
                      final total = entries.fold<double>(
                        0,
                        (sum, e) => sum + e.value.toDouble(),
                      );
                      final percentage = (value / total) * 100;

                      return PieChartSectionData(
                        color: colors[i % colors.length],
                        value: value,
                        // Hide title if less than 5% of the pie
                        title: percentage < 5
                            ? ''
                            : '${percentage.toStringAsFixed(0)}%',
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: List.generate(entries.length, (i) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          color: colors[i % colors.length],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${formatLabel(entries[i].key)} (${entries[i].value})',
                        ), // 👈 name + number
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String formatLabel(String text) {
  return text
      .split('_') // split into words
      .map((word) => word[0].toUpperCase() + word.substring(1)) // capitalize
      .join(' '); // join with space
}
