class HealthCheck {
  final String id;
  final String userId;
  final String complain;
  final int systolicBP;
  final int diastolicBP;
  final int pulseRate;
  final int fbs;
  final int postprandialSugar;
  final DateTime timestamp;
  String? doctorFeedback;
  bool? isStable;

  HealthCheck({
    required this.id,
    required this.userId,
    required this.complain,
    required this.systolicBP,
    required this.diastolicBP,
    required this.pulseRate,
    required this.fbs,
    required this.postprandialSugar,
    required this.timestamp,
    this.doctorFeedback,
    this.isStable,
  });
}
