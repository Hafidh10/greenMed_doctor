import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenmed_doctor/data/repositories/health_check_repository.dart';
import 'package:greenmed_doctor/models/health_check_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../controller/review_controller.dart';

class PatientDetailsScreen extends StatefulWidget {
  final HealthCheck healthCheck;

  const PatientDetailsScreen({super.key, required this.healthCheck});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final HealthCheckRepository _repository = HealthCheckRepository();
  Map<String, dynamic>? _patientProfile;
  late ReviewController controller;

  @override
  void initState() {
    super.initState();
    
    // Use Get.put and store the reference
    controller = Get.put(ReviewController());
    
    // Initialize the controller and its fields only once
    controller.feedbackController.text = widget.healthCheck.doctorFeedback ?? '';
    controller.medsController.text = widget.healthCheck.prescribedMeds ?? '';
    controller.priceController.text = widget.healthCheck.totalPrice?.toString() ?? '';
    
    _loadPatientProfile();
  }

  Future<void> _loadPatientProfile() async {
    try {
      final profile = await _repository.getPatientProfile(widget.healthCheck.userId);
      setState(() {
        _patientProfile = profile;
      });
    } catch (e) {
      // Silent error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Instead of using ReviewController.instance (which calls Get.find), 
    // we use the 'controller' reference we initialized in initState.
    final patientName = _patientProfile != null 
        ? '${_patientProfile!['first_name']} ${_patientProfile!['last_name']}'
        : 'Loading...';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Patient"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: SkiiveColors.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient: $patientName',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Submitted: ${widget.healthCheck.createdAt}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            _buildDetailCard('Chief Complaint', widget.healthCheck.complain, Icons.warning_amber_rounded),
            if (widget.healthCheck.feelingDescription != null)
              _buildDetailCard('Description', widget.healthCheck.feelingDescription!, Icons.description),
            if (widget.healthCheck.medications != null)
              _buildDetailCard('Current Meds', widget.healthCheck.medications!, Icons.medication),
            
            const SizedBox(height: 16),
            const Text('Vitals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildVitalsGrid(widget.healthCheck),
            
            const SizedBox(height: 32),
            const Text('Doctor\'s Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            _buildInputField('Clinical Feedback', controller.feedbackController, maxLines: 3),
            const SizedBox(height: 12),
            _buildInputField('Prescribed Medications', controller.medsController, maxLines: 3),
            const SizedBox(height: 12),
            _buildInputField('Total Price (RM)', controller.priceController, keyboardType: TextInputType.number),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => controller.submitReview(widget.healthCheck),
              style: ElevatedButton.styleFrom(
                backgroundColor: SkiiveColors.primary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
              ),
              child: const Text('Submit & Notify Patient', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: SkiiveColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: SkiiveColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: SkiiveColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsGrid(HealthCheck data) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.8, // Increased significantly to make grids much smaller/shorter
      children: [
        _buildVitalTile('BP', '${data.systolicBP.toInt()}/${data.diastolicBP.toInt()}', 'mmHg'),
        _buildVitalTile('Pulse', data.pulseRate.toInt().toString(), 'bpm'),
        if (data.fbs != null) _buildVitalTile('FBS', data.fbs.toString(), 'mmol/L'),
        if (data.postprandialSugar != null) _buildVitalTile('Post-Meal', data.postprandialSugar.toString(), 'mmol/L'),
        if (data.hba1c != null) _buildVitalTile('HbA1c', data.hba1c.toString(), '%'),
        if (data.weight != null) _buildVitalTile('Weight', data.weight.toString(), 'kg'),
      ],
    );
  }

  Widget _buildVitalTile(String label, String value, String unit) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: SkiiveColors.primary)),
          Text(unit, style: const TextStyle(fontSize: 8, color: Colors.grey)),
        ],
      ),
    );
  }
}
