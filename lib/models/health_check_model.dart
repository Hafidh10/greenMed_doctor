enum HealthCheckStatus { pending, reviewed, paid, completed }

class HealthCheck {
  final String? id;
  final String userId;
  final String complain;
  final String? feelingDescription;
  final String? medications;
  final double systolicBP;
  final double diastolicBP;
  final double pulseRate;
  final double fbs;
  final double postprandialSugar;
  final double? hba1c;
  final double? cholesterol;
  final double? triglyceride;
  final double? height;
  final double? weight;
  final DateTime createdAt;
  final HealthCheckStatus status;
  String? doctorFeedback;
  String? prescribedMeds;
  double? totalPrice;
  String? paymentReference;
  bool? isStable;

  HealthCheck({
    this.id,
    required this.userId,
    required this.complain,
    this.feelingDescription,
    this.medications,
    required this.systolicBP,
    required this.diastolicBP,
    required this.pulseRate,
    required this.fbs,
    required this.postprandialSugar,
    this.hba1c,
    this.cholesterol,
    this.triglyceride,
    this.height,
    this.weight,
    required this.createdAt,
    this.status = HealthCheckStatus.pending,
    this.doctorFeedback,
    this.prescribedMeds,
    this.totalPrice,
    this.paymentReference,
    this.isStable,
  });

  factory HealthCheck.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic val) {
      if (val is num) return val.toDouble();
      return 0.0;
    }

    double? toDoubleNullable(dynamic val) {
      if (val is num) return val.toDouble();
      return null;
    }

    return HealthCheck(
      id: json['id']?.toString(),
      userId: json['user_id'] ?? '',
      complain: json['complain'] ?? '',
      feelingDescription: json['feeling_description'],
      medications: json['medications'],
      systolicBP: toDouble(json['systolic_bp']),
      diastolicBP: toDouble(json['diastolic_bp']),
      pulseRate: toDouble(json['pulse_rate']),
      fbs: toDouble(json['fbs']),
      postprandialSugar: toDouble(json['postprandial_sugar']),
      hba1c: toDoubleNullable(json['hba1c']),
      cholesterol: toDoubleNullable(json['cholesterol']),
      triglyceride: toDoubleNullable(json['triglyceride']),
      height: toDoubleNullable(json['height']),
      weight: toDoubleNullable(json['weight']),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      status: HealthCheckStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => HealthCheckStatus.pending,
      ),
      doctorFeedback: json['doctor_feedback'],
      prescribedMeds: json['prescribed_meds'],
      totalPrice: toDoubleNullable(json['total_price']),
      paymentReference: json['payment_reference'],
      isStable: json['is_stable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'complain': complain,
      'feeling_description': feelingDescription,
      'medications': medications,
      'systolic_bp': systolicBP,
      'diastolic_bp': diastolicBP,
      'pulse_rate': pulseRate,
      'fbs': fbs,
      'postprandial_sugar': postprandialSugar,
      'hba1c': hba1c,
      'cholesterol': cholesterol,
      'triglyceride': triglyceride,
      'height': height,
      'weight': weight,
      'status': status.name,
      'doctor_feedback': doctorFeedback,
      'prescribed_meds': prescribedMeds,
      'total_price': totalPrice,
      'payment_reference': paymentReference,
      'is_stable': isStable,
    };
  }
}
