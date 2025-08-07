// features/profile/screens/profile_screen.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'widgets/eco_level.dart';
import 'models/achievement_model.dart';
import 'services/achievement_service.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentPoints = 0;
  int currentLevel = 1;
  int totalPointsForNextLevel = 100;
  int pointsToNextLevel = 100;
  List<Achievement> achievements = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final points = await getUserPoints();
    final level = await getUserLevel();
    final achievementList = await AchievementService.getAchievements();
    
    setState(() {
      currentPoints = points;
      currentLevel = level;
      totalPointsForNextLevel = level * 50 + 50;
      pointsToNextLevel = totalPointsForNextLevel - points;
      achievements = achievementList;
    });
  }

  Future<int> getUserPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("Points") ?? 0;
  }

  Future<void> addUserPoints(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int originalPoints = prefs.getInt("Points") ?? 0;
    int newPoints = originalPoints + amount;
    
    // 레벨업 체크
    int newLevel = currentLevel;
    int remainingPoints = newPoints;
    
    while (remainingPoints >= (newLevel * 50 + 50)) {
      remainingPoints -= (newLevel * 50 + 50);
      newLevel++;
    }
    
    await prefs.setInt("Points", remainingPoints);
    await prefs.setInt("Level", newLevel);
    
    // 사용자 스탯 업데이트
    await AchievementService.updateUserStat('currentLevel', newLevel);
    
    // 레벨업 시 achievement 체크
    if (newLevel > currentLevel) {
      _checkNewAchievements();
    }
    
    _loadData(); // 데이터 재로드
  }

  Future<int> getUserLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("Level") ?? 1;
  }

  Future<void> _checkNewAchievements() async {
    final newlyCompleted = await AchievementService.checkAndUpdateAchievements();
    
    for (var achievement in newlyCompleted) {
      await addUserPoints(achievement.pointReward);
      _showAchievementDialog(achievement);
    }
    
    _loadData(); // 데이터 재로드
  }

  void _showAchievementDialog(Achievement achievement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(achievement.icon, color: achievement.color, size: 28),
              const SizedBox(width: 8),
              const Text('Achievement Unlocked!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                achievement.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(achievement.description),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${achievement.pointReward} Points!',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Awesome!'),
            ),
          ],
        );
      },
    );
  }

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
              // 테스트용 버튼들 (개발 중에만 사용)
              _buildTestButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestButtons() {
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
          const Text(
            'Test Actions (Dev Only)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await AchievementService.incrementUserStat('daysTracked');
                    _checkNewAchievements();
                  },
                  child: const Text('Add Day'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await AchievementService.incrementUserStat('carbonSaved', amount: 50.0);
                    _checkNewAchievements();
                  },
                  child: const Text('Add 50g CO₂'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await addUserPoints(25);
              },
              child: const Text('Add 25 Points'),
            ),
          ),
        ],
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
            'Achievements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          ...achievements.take(5).map((achievement) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildAchievementItem(achievement),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(Achievement achievement) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achievement.isCompleted 
            ? achievement.color.withValues(alpha: 0.1) 
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: achievement.isCompleted 
              ? achievement.color.withValues(alpha: 0.3) 
              : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: achievement.isCompleted ? achievement.color : Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  achievement.isCompleted ? achievement.icon : Icons.lock_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          achievement.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: achievement.isCompleted ? Colors.grey[800] : Colors.grey[500],
                          ),
                        ),
                        Text(
                          '+${achievement.pointReward}pts',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: achievement.isCompleted ? achievement.color : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      achievement.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: achievement.isCompleted ? Colors.grey[600] : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              if (achievement.isCompleted)
                Icon(
                  Icons.check_circle,
                  color: achievement.color,
                  size: 20,
                ),
            ],
          ),
          if (!achievement.isCompleted && achievement.targetValue > 0)
            Column(
              children: [
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: achievement.progressPercentage,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(achievement.color),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress: ${achievement.currentProgress}/${achievement.targetValue}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      '${(achievement.progressPercentage * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
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
    await _loadData();
    await _checkNewAchievements();
  }
}