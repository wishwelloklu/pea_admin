// ignore: unused_import
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:prayer_palace_admin/core/func/app_colors.dart';
import 'package:prayer_palace_admin/providers/attendance_notifier.dart';
import 'package:prayer_palace_admin/widgets/histogram.dart';
import 'package:prayer_palace_admin/widgets/stats_pie_chart.dart';
import 'package:prayer_palace_admin/widgets/stats_summary_cards.dart';

class Attendance extends ConsumerStatefulWidget {
  const Attendance({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AttendanceState();
}

class _AttendanceState extends ConsumerState<Attendance> {
  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(attendanceProvider);
    return statsAsync.when(
      data: (stats) {
        return RefreshIndicator.adaptive(
          onRefresh: () async =>
              await ref.read(attendanceProvider.notifier).refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 12),
              StatsSummaryCards(data: stats.attendanceTotal, label: 'Total'),
              const SizedBox(height: 20),
              StatsPieChart(
                title: "Gender",
                data: stats.gender,
                colors: generateColors(stats.gender.length),
              ),

              const SizedBox(height: 50),
              Histogram(
                title: "Membership Status",
                data: stats.memberStatus,
                colors: generateColors(
                  stats.memberStatus.length,
                ).reversed.toList(),
              ),
              const SizedBox(height: 20),
              const Center(child: Text("Auto-refreshes every 30 seconds")),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
