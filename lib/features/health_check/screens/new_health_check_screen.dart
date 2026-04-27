
import 'package:flutter/material.dart';
import 'dart:math';

import '../../../utils/constants/colors.dart';
import '../models/health_check_model.dart';

// A widget to represent a selectable symptom
class SymptomChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const SymptomChip({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Chip(
        avatar: Icon(icon, color: isSelected ? Colors.white : SkiiveColors.primary),
        label: Text(label),
        backgroundColor: isSelected ? SkiiveColors.primary : Colors.grey.shade200,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}

// A widget for slider input
class MeasurementSlider extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const MeasurementSlider({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: SkiiveColors.primary, size: 28),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(value.round().toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.round().toString(),
          onChanged: onChanged,
          activeColor: SkiiveColors.primary,
        ),
      ],
    );
  }
}


class NewHealthCheckScreen extends StatefulWidget {
  const NewHealthCheckScreen({super.key});

  @override
  State<NewHealthCheckScreen> createState() => _NewHealthCheckScreenState();
}

class _NewHealthCheckScreenState extends State<NewHealthCheckScreen> {
  // State for selected symptoms
  final Map<String, bool> _symptoms = {
    'Headache': false,
    'Fever': false,
    'Cough': false,
    'Dizziness': false,
    'Fatigue': false,
    'Nausea': false,
  };

  // State for slider values
  double _systolicBP = 120;
  double _diastolicBP = 80;
  double _pulseRate = 70;
  double _fbs = 90;
  double _postprandialSugar = 120;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Health Check'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Complaint Section
            const Text('What are you feeling?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _symptoms.keys.map((symptom) {
                return SymptomChip(
                  label: symptom,
                  icon: _getSymptomIcon(symptom),
                  isSelected: _symptoms[symptom]!,
                  onSelected: () {
                    setState(() {
                      _symptoms[symptom] = !_symptoms[symptom]!;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Measurement Sliders
            MeasurementSlider(
              label: 'Systolic BP',
              icon: Icons.favorite_border,
              value: _systolicBP,
              min: 70,
              max: 200,
              onChanged: (val) => setState(() => _systolicBP = val),
            ),
            const SizedBox(height: 16),
            MeasurementSlider(
              label: 'Diastolic BP',
              icon: Icons.favorite,
              value: _diastolicBP,
              min: 40,
              max: 120,
              onChanged: (val) => setState(() => _diastolicBP = val),
            ),
            const SizedBox(height: 16),
            MeasurementSlider(
              label: 'Pulse Rate',
              icon: Icons.monitor_heart,
              value: _pulseRate,
              min: 40,
              max: 180,
              onChanged: (val) => setState(() => _pulseRate = val),
            ),
             const SizedBox(height: 16),
            MeasurementSlider(
              label: 'Fasting Blood Sugar',
              icon: Icons.water_drop_outlined,
              value: _fbs,
              min: 50,
              max: 300,
              onChanged: (val) => setState(() => _fbs = val),
            ),
             const SizedBox(height: 16),
            MeasurementSlider(
              label: 'Post-Meal Blood Sugar',
              icon: Icons.water_drop,
              value: _postprandialSugar,
              min: 50,
              max: 400,
              onChanged: (val) => setState(() => _postprandialSugar = val),
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: () {
                  final selectedComplaints = _symptoms.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
                      .join(', ');

                  final newCheck = HealthCheck(
                    id: Random().nextInt(1000).toString(), // temporary id
                    userId: 'test_user', // temporary user id
                    complain: selectedComplaints.isEmpty ? 'No complaint' : selectedComplaints,
                    systolicBP: _systolicBP.round(),
                    diastolicBP: _diastolicBP.round(),
                    pulseRate: _pulseRate.round(),
                    fbs: _fbs.round(),
                    postprandialSugar: _postprandialSugar.round(),
                    timestamp: DateTime.now(),
                  );
                  // In a real app, you would send this to a backend.
                  print('New Health Check: ${newCheck.complain}');
                  Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SkiiveColors.primary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getSymptomIcon(String symptom) {
    switch (symptom) {
      case 'Headache': return Icons.self_improvement;
      case 'Fever': return Icons.local_fire_department;
      case 'Cough': return Icons.sick_outlined;
      case 'Dizziness': return Icons.rotate_right;
      case 'Fatigue': return Icons.battery_alert;
      case 'Nausea': return Icons.coronavirus_outlined;
      default: return Icons.help_outline;
    }
  }
}
