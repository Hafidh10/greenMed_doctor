import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../health_check/screens/health_history_screen.dart';
import '../../../../health_check/screens/new_health_check_screen.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewHealthCheckScreen()),
              );
            },
            icon: const Icon(Icons.assignment),
            label: const Text("New Health Check"),
            style: ElevatedButton.styleFrom(
              backgroundColor: SkiiveColors.primary,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HealthHistoryScreen()),
              );
            },
            icon: const Icon(Icons.history),
            label: const Text("View Health History"),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(color: SkiiveColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
