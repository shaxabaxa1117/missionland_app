// features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'widgets/eco_level.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 예시 데이터 - 실제로는 사용자 데이터에서 가져와야 함
  int currentPoints = 2450;
  int currentLevel = 12;
  int pointsToNextLevel = 550;
  int totalPointsForNextLevel = 3000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showSettings,
            icon: Icon(
              Icons.settings,
              color: Colors.grey[600],
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              EcoLevelWidget(
                currentPoints: currentPoints,
                currentLevel: currentLevel,
                pointsToNextLevel: pointsToNextLevel,
                totalPointsForNextLevel: totalPointsForNextLevel,
              ),
              const SizedBox(height: 20),
              _buildAchievementsSection(),
              const SizedBox(height: 20),
              _buildHistorySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Achievements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildAchievementItem(
            'First Week Complete',
            'Completed your first week of tracking!',
            Icons.celebration,
            Colors.purple[600]!,
            true,
          ),
          const SizedBox(height: 12),
          _buildAchievementItem(
            'Carbon Saver',
            'Saved 100g of CO₂ emissions',
            Icons.eco,
            Colors.green[600]!,
            true,
          ),
          const SizedBox(height: 12),
          _buildAchievementItem(
            'Week Warrior',
            'Stay under daily limits for a full week',
            Icons.shield,
            Colors.blue[600]!,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(String title, String description, IconData icon, Color color, bool completed) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: completed ? color.withValues(alpha: 0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: completed ? color.withValues(alpha: 0.3) : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: completed ? color : Colors.grey[400],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              completed ? icon : Icons.lock_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: completed ? Colors.grey[800] : Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: completed ? Colors.grey[600] : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          if (completed)
            Icon(
              Icons.check_circle,
              color: color,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildHistoryItem(
            'Daily Goal Achieved',
            'Stayed under 200g CO₂ limit',
            '2 hours ago',
            Icons.task_alt,
            Colors.green[600]!,
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            'New App Added',
            'Started tracking Instagram',
            '1 day ago',
            Icons.add_circle,
            Colors.blue[600]!,
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            'Level Up!',
            'Reached Eco Level 12',
            '3 days ago',
            Icons.arrow_upward,
            Colors.purple[600]!,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String title, String description, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  void _showSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  Future<void> _refreshData() async {
    // 실제 데이터 새로고침 로직
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      // 데이터 업데이트
    });
  }
}