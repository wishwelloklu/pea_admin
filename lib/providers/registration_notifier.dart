import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_palace_admin/core/services/dio_client.dart';
import 'package:prayer_palace_admin/models/stats_data.dart';

final regDateProvider = StateProvider<String>((_) => 'all');
final registrationProvider =
    AsyncNotifierProvider<RegistrationNotifier, StatsData>(
      RegistrationNotifier.new,
    );

class RegistrationNotifier extends AsyncNotifier<StatsData> {
  Timer? _timer;

  @override
  Future<StatsData> build() async {
    final date = ref.watch(regDateProvider);

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
      '/api/members/register-dashboard/$date',
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
