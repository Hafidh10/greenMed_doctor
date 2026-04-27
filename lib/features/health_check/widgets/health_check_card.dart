import 'package:flutter/material.dart';

import '../models/health_check_model.dart';

class HealthCheckCard extends StatelessWidget {
  final HealthCheck healthCheck;

  const HealthCheckCard({super.key, required this.healthCheck});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              healthCheck.complain,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${healthCheck.timestamp.toLocal()}'.split(' ')[0]),
            const SizedBox(height: 16),
            if (healthCheck.doctorFeedback != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: healthCheck.isStable == true ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      healthCheck.isStable == true ? Icons.check_circle : Icons.warning,
                      color: healthCheck.isStable == true ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            healthCheck.isStable == true ? 'Doctor says: You are stable' : 'Doctor says: Seek medical attention',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(healthCheck.doctorFeedback!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
