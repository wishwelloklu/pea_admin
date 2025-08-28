import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_palace_admin/core/services/dio_client.dart';
import 'package:prayer_palace_admin/models/stats_data.dart';

final dateProvider = StateProvider<String>(
  (_) => DateTime.now().toIso8601String().split("T").first,
);
final attendanceProvider =
    AsyncNotifierProvider<AttendanceNotifier, StatsData>(
      AttendanceNotifier.new,
    );

class AttendanceNotifier extends AsyncNotifier<StatsData> {
  Timer? _timer;

  @override
  Future<StatsData> build() async {
    final date = ref.watch(dateProvider);

    // Auto-refresh every 30 seconds
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => ref.invalidateSelf(),
    );
    ref.onDispose(() => _timer?.cancel());

    return _fetchData(date);
  }

  Future<StatsData> _fetchData(String date) async {
    final response = await DioClient().get(
      '/api/members/attendance-dashboard/$date',
    );
    if (response.isSuccess) {
      return StatsData.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  // Manual refresh
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
