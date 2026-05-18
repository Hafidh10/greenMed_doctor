import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenmed_doctor/data/repositories/authentication_repositories.dart';
import 'package:greenmed_doctor/data/repositories/health_check_repository.dart';
import 'package:greenmed_doctor/features/authentication/screens/home/widgets/greeting_card.dart';
import 'package:greenmed_doctor/features/authentication/screens/patient_details/patient_details_screen.dart';
import 'package:greenmed_doctor/models/health_check_model.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repository = HealthCheckRepository();
  String _selectedFilter = 'pending'; // 'pending' or 'reviewed'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: CustomScrollView(
        slivers: [
          // 1. Elegant Header with Greeting
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: SkiiveColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [SkiiveColors.primary, SkiiveColors.primary.withOpacity(0.85)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: GreetingCard(),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.logout, color: Colors.white),
                onPressed: () => AuthenticationRepository.instance.logout(),
                tooltip: 'Logout',
              ),
              const SizedBox(width: 8),
            ],
          ),

          // 2. Interactive Summary Stats Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Pending Count (Filter Trigger)
                    StreamBuilder<List<HealthCheck>>(
                      stream: repository.getPendingHealthChecks(),
                      builder: (context, snapshot) {
                        final count = snapshot.hasData ? snapshot.data!.length : 0;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = 'pending'),
                          child: _buildStatCard(
                            "Total Pending", 
                            count.toString(), 
                            Iconsax.timer, 
                            Colors.orange,
                            isSelected: _selectedFilter == 'pending',
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),

                    // Reviewed Today Count (Filter Trigger)
                    StreamBuilder<int>(
                      stream: repository.getTodayReviewedCount(),
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = 'reviewed'),
                          child: _buildStatCard(
                            "Reviewed Today", 
                            count.toString(), 
                            Iconsax.tick_circle, 
                            Colors.green,
                            isSelected: _selectedFilter == 'reviewed',
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),

                    // System Status
                    _buildStatCard("System Status", "Active", Iconsax.activity, Colors.blue),
                  ],
                ),
              ),
            ),
          ),

          // 3. Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedFilter == 'pending' ? "Patient Queue" : "Completed Today",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Icon(_selectedFilter == 'pending' ? Iconsax.receipt_search : Iconsax.task_square, size: 20, color: Colors.grey),
                ],
              ),
            ),
          ),

          // 4. Patient Queue List
          StreamBuilder<List<HealthCheck>>(
            stream: _selectedFilter == 'pending' 
                ? repository.getPendingHealthChecks() 
                : repository.getTodayReviewedHealthChecks(),
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
                        Icon(_selectedFilter == 'pending' ? Iconsax.folder_open : Iconsax.ghost, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFilter == 'pending' ? 'All caught up!' : 'No reviews yet today.', 
                          style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)
                        ),
                        Text(
                          _selectedFilter == 'pending' ? 'No pending patient reviews.' : 'Start reviewing patients to see them here.', 
                          style: const TextStyle(color: Colors.grey, fontSize: 13)
                        ),
                      ],
                    ),
                  ),
                );
              }

              final healthChecks = snapshot.data!;
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final healthCheck = healthChecks[index];
                      return FutureBuilder<Map<String, dynamic>>(
                        future: repository.getPatientProfile(healthCheck.userId),
                        builder: (context, profileSnapshot) {
                          final patientName = profileSnapshot.hasData 
                              ? '${profileSnapshot.data!['first_name']} ${profileSnapshot.data!['last_name']}'
                              : 'Patient Profile...';
                          
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

  Widget _buildStatCard(String label, String value, IconData icon, Color color, {bool isSelected = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? Border.all(color: color, width: 2) : Border.all(color: Colors.transparent, width: 2),
        boxShadow: [
          BoxShadow(
            color: isSelected ? color.withOpacity(0.1) : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildModernPatientCard(BuildContext context, HealthCheck healthCheck, String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
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
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: SkiiveColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0] : 'P',
                      style: const TextStyle(
                        color: SkiiveColors.primary,
                        fontSize: 20,
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            healthCheck.status == HealthCheckStatus.reviewed ? Iconsax.tick_circle : Iconsax.info_circle, 
                            size: 14, 
                            color: healthCheck.status == HealthCheckStatus.reviewed ? Colors.green : Colors.orange[400]
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              healthCheck.complain,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
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
                    if (healthCheck.systolicBP != null && healthCheck.diastolicBP != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${healthCheck.systolicBP!.toInt()}/${healthCheck.diastolicBP!.toInt()}",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (healthCheck.temperature != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${healthCheck.temperature}°C",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    const Icon(Iconsax.arrow_right_3, size: 16, color: Colors.grey),
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
