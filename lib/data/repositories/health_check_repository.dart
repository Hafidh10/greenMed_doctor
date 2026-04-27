import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:greenmed_doctor/models/health_check_model.dart';

class HealthCheckRepository {
  final _supabase = Supabase.instance.client;

  // Get a stream of all pending health checks for the doctor's app
  Stream<List<HealthCheck>> getPendingHealthChecks() {
    return _supabase
        .from('health_checks')
        .stream(primaryKey: ['id'])
        .eq('status', 'pending')
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => HealthCheck.fromJson(json)).toList());
  }

  Future<void> updateHealthCheck(HealthCheck healthCheck) async {
    try {
      // Create a map with snake_case keys for Supabase update
      final updateData = {
        'status': healthCheck.status.name,
        'doctor_feedback': healthCheck.doctorFeedback,
        'prescribed_meds': healthCheck.prescribedMeds,
        'total_price': healthCheck.totalPrice,
        // Removed 'is_stable' as it does not exist in the database schema
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
