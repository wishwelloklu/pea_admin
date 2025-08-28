import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prayer_palace_admin/core/func/app_colors.dart';

class Histogram extends StatelessWidget {
  final Map<String, dynamic> data;
  final String title;
  final List<Color> colors;

  const Histogram({
    super.key,
    required this.data,
    required this.title,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final chartData = Map.of(data)..remove("total");
    final entries = chartData.entries.toList();
    final isEmptyData = entries.every((key) => key.value == 0);
    // Calculate total for percentage calculation
    final total = entries.fold<double>(0, (sum, e) => sum + e.value.toDouble());

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
          child: Stack(
            children: [
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: isEmptyData
                        ? 0
                        : entries
                                  .map((e) => e.value.toDouble() / total * 100)
                                  .reduce((a, b) => a > b ? a : b) +
                              10, // Add padding for labels
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= entries.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${formatLabel(entries[index].key)}(${entries[index].value})',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ), // No left axis
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            final index = val.toInt();
                            final value = entries[index].value.toDouble();
                            final percentage = (value / total) * 100;
                            return Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: const FlGridData(
                      show: false,
                    ), // No background grid
                    borderData: FlBorderData(show: false),
                    barGroups: isEmptyData
                        ? null
                        : List.generate(entries.length, (i) {
                            final value = entries[i].value.toDouble();
                            final percentage = (value / total) * 100;

                            return BarChartGroupData(
                              x: i,

                              barRods: [
                                BarChartRodData(
                                  toY: percentage,
                                  color: colors[i % colors.length],
                                  width: MediaQuery.sizeOf(context).width * .2,
                                  borderRadius: BorderRadius.circular(4),
                                  // Show percentage label above bar
                                  rodStackItems: [],
                                ),
                              ],
                              showingTooltipIndicators: [],
                            );
                          }),
                    // extraLinesData: ExtraLinesData(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
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
