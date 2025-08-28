class StatsData {
  final Map<String, int> gender;
  final Map<String, int> memberStatus;
  final int memberTotal;
  final int attendanceTotal;

  StatsData({
    required this.gender,
    required this.memberStatus,
    required this.memberTotal,
    required this.attendanceTotal,
  });

  factory StatsData.fromJson(Map<String, dynamic> json) {
    final gender = Map<String, int>.from(json['gender']);
    final membersStatus = Map<String, int>.from(json['status']);


    final attendanceTotal = gender['total'] ?? 0;

    final memberTotal = membersStatus['total'] ?? 0;

    return StatsData(
      gender: gender,
      memberStatus: membersStatus,
      memberTotal: memberTotal,
      attendanceTotal: attendanceTotal,
    );
  }
}
