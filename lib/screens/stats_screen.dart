import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_palace_admin/providers/attendance_notifier.dart';
import 'package:prayer_palace_admin/providers/registration_notifier.dart';
import 'package:prayer_palace_admin/screens/attendance.dart';
import 'package:prayer_palace_admin/screens/registrations.dart';
import 'package:prayer_palace_admin/widgets/attendance_filter.dart';
import 'package:prayer_palace_admin/widgets/registration_filter.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = ref.watch(dateProvider);
    final currentRegDate = ref.watch(regDateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          if (_tabController.index == 0)
            AttendanceFilter(currentDate: currentDate, ref: ref)
          else
            RegistrationFilter(currentDate: currentRegDate, ref: ref),
        ],
        bottom: TabBar(
          controller: _tabController,

          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
          tabs: [
            Tab(text: 'Attendance'),
            Tab(text: 'Registration'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [Attendance(), Registrations()],
      ),
    );
  }

  // Dynamically create colors for charts
}
