import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:greenmed_doctor/models/health_check_model.dart';

class HealthCheckRepository {
  final _supabase = Supabase.instance.client;

  // Get a stream of all pending health checks
  Stream<List<HealthCheck>> getPendingHealthChecks() {
    return _supabase
        .from('health_checks')
        .stream(primaryKey: ['id'])
        .eq('status', 'pending')
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => HealthCheck.fromJson(json)).toList());
  }

  // Get count of reviews completed today (Using UTC for Supabase compatibility)
  // Note: SupabaseStreamBuilder only supports a limited set of filters. 
  // For complex logic like date ranges, we filter client-side to keep real-time updates.
  Stream<int> getTodayReviewedCount() {
    final midnight = DateTime.now()
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)
        .toUtc();
    
    return _supabase
        .from('health_checks')
        .stream(primaryKey: ['id'])
        .eq('status', 'reviewed')
        .map((data) {
          return data.where((json) {
            final createdAt = DateTime.parse(json['created_at']);
            return createdAt.isAfter(midnight);
          }).length;
        });
  }

  // Get list of health checks reviewed today
  Stream<List<HealthCheck>> getTodayReviewedHealthChecks() {
    final midnight = DateTime.now()
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)
        .toUtc();
    
    return _supabase
        .from('health_checks')
        .stream(primaryKey: ['id'])
        .eq('status', 'reviewed')
        .order('created_at', ascending: false)
        .map((data) {
          return data
              .where((json) {
                final createdAt = DateTime.parse(json['created_at']);
                return createdAt.isAfter(midnight);
              })
              .map((json) => HealthCheck.fromJson(json))
              .toList();
        });
  }

  Future<void> updateHealthCheck(HealthCheck healthCheck) async {
    try {
      final updateData = {
        'status': healthCheck.status.name,
        'doctor_feedback': healthCheck.doctorFeedback,
        'prescribed_meds': healthCheck.prescribedMeds,
        'total_price': healthCheck.totalPrice,
        'is_viewed': false,
      };

      await _supabase
          .from('health_checks')
          .update(updateData)
          .eq('id', healthCheck.id!);
    } catch (e) {
      throw Exception('Failed to update health check: $e');
    }
  }

  // Get patient details by ID (from profiles table)
  Future<Map<String, dynamic>> getPatientProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch patient profile: $e');
    }
  }
}
