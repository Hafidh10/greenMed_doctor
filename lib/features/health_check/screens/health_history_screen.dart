import 'package:flutter/material.dart';

import '../models/health_check_model.dart';
import '../widgets/health_check_card.dart';

class HealthHistoryScreen extends StatelessWidget {
  const HealthHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with actual data from your backend
    final healthChecks = [
      HealthCheck(
        id: '1',
        userId: 'test_user',
        complain: 'Headache and fatigue',
        systolicBP: 120,
        diastolicBP: 80,
        pulseRate: 72,
        fbs: 90,
        postprandialSugar: 140,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        doctorFeedback: 'Your results are within the normal range. Monitor your symptoms and rest.',
        isStable: true,
      ),
      HealthCheck(
        id: '2',
        userId: 'test_user',
        complain: 'Dizziness and shortness of breath',
        systolicBP: 145,
        diastolicBP: 92,
        pulseRate: 88,
        fbs: 110,
        postprandialSugar: 180,
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        doctorFeedback: 'Your blood pressure is slightly elevated. Please schedule a follow-up appointment.',
        isStable: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health History'),
      ),
      body: ListView.builder(
        itemCount: healthChecks.length,
        itemBuilder: (context, index) {
          return HealthCheckCard(healthCheck: healthChecks[index]);
        },
      ),
    );
  }
}
