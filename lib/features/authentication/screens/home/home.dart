import 'package:flutter/material.dart';
import 'package:greenmed_doctor/data/repositories/health_check_repository.dart';
import 'package:greenmed_doctor/features/authentication/screens/home/widgets/greeting_card.dart';
import 'package:greenmed_doctor/features/authentication/screens/patient_details/patient_details_screen.dart';
import 'package:greenmed_doctor/models/health_check_model.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = HealthCheckRepository();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: CustomScrollView(
        slivers: [
          // Elegant App Bar with Greeting
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: SkiiveColors.primary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [SkiiveColors.primary, SkiiveColors.primary.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: GreetingCard(), // Reusing the updated greeting card logic
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.notification, color: Colors.white),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Statistics/Summary Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Pending Reviews",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View All", style: TextStyle(color: SkiiveColors.primary)),
                  ),
                ],
              ),
            ),
          ),

          // Main Content: Stream of Health Checks
          StreamBuilder<List<HealthCheck>>(
            stream: repository.getPendingHealthChecks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: SkiiveColors.primary)),
                );
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.folder_open, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text('All caught up!', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)),
                        const Text('No pending patient reviews.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }

              final healthChecks = snapshot.data!;
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final healthCheck = healthChecks[index];
                      return FutureBuilder<Map<String, dynamic>>(
                        future: repository.getPatientProfile(healthCheck.userId),
                        builder: (context, profileSnapshot) {
                          final patientName = profileSnapshot.hasData 
                              ? '${profileSnapshot.data!['first_name']} ${profileSnapshot.data!['last_name']}'
                              : 'Loading...';
                          
                          return _buildModernPatientCard(context, healthCheck, patientName);
                        },
                      );
                    },
                    childCount: healthChecks.length,
                  ),
                ),
              );
            },
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildModernPatientCard(BuildContext context, HealthCheck healthCheck, String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientDetailsScreen(healthCheck: healthCheck),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Patient Avatar/Initials
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: SkiiveColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0] : 'P',
                      style: const TextStyle(
                        color: SkiiveColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Iconsax.info_circle, size: 14, color: Colors.orange[400]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              healthCheck.complain,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('h:mm a • d MMM').format(healthCheck.createdAt),
                        style: TextStyle(fontSize: 11, color: Colors.grey[400], fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                
                // Vital Stats Summary (Mini)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${healthCheck.systolicBP}/${healthCheck.diastolicBP}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Icon(Iconsax.arrow_right_3, size: 18, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
