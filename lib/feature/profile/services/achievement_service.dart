// services/achievement_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/achievement_model.dart';

class AchievementService {
  static const String _achievementsKey = 'achievements';
  static const String _userStatsKey = 'user_stats';

  static List<Achievement> getDefaultAchievements() {
    return [
      Achievement(
        id: 'mission1',
        title: 'My First Missionland',
        description: 'Complete your first mission on missonland!',
        icon: Icons.celebration,
        color: Colors.yellow[600]!,
        pointReward: 50,
        type: AchievementType.doMissions,
        targetValue: 1,
      ),
      Achievement(
        id: 'mission2',
        title: 'Don\'t Give Up!',
        description: 'Complete your second mission on missonland!',
        icon: Icons.celebration,
        color: Colors.orange[600]!,
        pointReward: 75,
        type: AchievementType.doMissions,
        targetValue: 2,
      ),
      Achievement(
        id: 'mission7',
        title: 'Bye, Histoweek!',
        description: 'Complete whole missions on histoweek!',
        icon: Icons.celebration,
        color: Colors.purple[600]!,
        pointReward: 200,
        type: AchievementType.doMissions,
        targetValue: 7,
      ),
      Achievement(
        id: 'mission14',
        title: 'Bye, Revoweek!',
        description: 'Complete whole missions on Revoweek!',
        icon: Icons.celebration,
        color: Colors.purple[600]!,
        pointReward: 200,
        type: AchievementType.doMissions,
        targetValue: 14,
      ),
      Achievement(
        id: 'mission21',
        title: 'Bye, Presweek!',
        description: 'Complete whole missions on Presweek!',
        icon: Icons.celebration,
        color: Colors.purple[600]!,
        pointReward: 200,
        type: AchievementType.doMissions,
        targetValue: 21,
      ),
      Achievement(
        id: 'mission28',
        title: 'Bye, Futuweek!',
        description: 'Complete whole missions on Futuweek!',
        icon: Icons.celebration,
        color: Colors.purple[600]!,
        pointReward: 200,
        type: AchievementType.doMissions,
        targetValue: 28,
      ),
      Achievement(
        id: 'three_days',
        title: 'Do You Know Jaksimsamil?',
        description: 'Complete three days streak!',
        icon: Icons.celebration,
        color: Colors.purple[600]!,
        pointReward: 50,
        type: AchievementType.daysTracked,
        targetValue: 3,
      ),
      Achievement(
        id: 'first_week',
        title: 'First Week Streak',
        description: 'Complete seven days streak!',
        icon: Icons.celebration,
        color: Colors.purple[600]!,
        pointReward: 100,
        type: AchievementType.daysTracked,
        targetValue: 7,
      ),
      Achievement(
        id: 'first_month',
        title: 'First Month Streak',
        description: 'Complete seven days streak!',
        icon: Icons.celebration,
        color: Colors.purple[600]!,
        pointReward: 200,
        type: AchievementType.daysTracked,
        targetValue: 30,
      ),
      Achievement(
        id: 'hundred_days',
        title: '100 Days Streak',
        description: 'Complete hundred days streak!',
        icon: Icons.celebration,
        color: Colors.purple[600]!,
        pointReward: 500,
        type: AchievementType.daysTracked,
        targetValue: 100,
      ),
      Achievement(
        id: 'week_warrior',
        title: 'Week Warrior',
        description: 'Stay under daily limits for a full week!',
        icon: Icons.shield,
        color: Colors.blue[600]!,
        pointReward: 75,
        type: AchievementType.consecutiveDays,
        targetValue: 7,
      ),
    ];
  }

  static Future<List<Achievement>> getAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = prefs.getString(_achievementsKey);
    
    if (achievementsJson == null) {
      // 첫 실행시 기본 achievements 저장
      final defaultAchievements = getDefaultAchievements();
      await saveAchievements(defaultAchievements);
      return defaultAchievements;
    }
    
    final List<dynamic> jsonList = jsonDecode(achievementsJson);
    final achievements = jsonList.map((json) => Achievement.fromJson(json)).toList();
    
    // 아이콘과 색상 재설정 (JSON에서 복원 불가능한 부분)
    final defaultAchievements = getDefaultAchievements();
    for (var achievement in achievements) {
      final defaultAchievement = defaultAchievements.firstWhere(
        (a) => a.id == achievement.id,
        orElse: () => defaultAchievements.first,
      );
      achievement.icon = defaultAchievement.icon;
      achievement.color = defaultAchievement.color;
    }
    
    return achievements;
  }

  static Future<void> saveAchievements(List<Achievement> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = achievements.map((a) => a.toJson()).toList();
    await prefs.setString(_achievementsKey, jsonEncode(jsonList));
  }

  static Future<Map<String, dynamic>> getUserStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_userStatsKey);
    
    if (statsJson == null) {
      return {
        'daysTracked': 0,
        'carbonSaved': 0.0,
        'consecutiveDays': 0,
        'totalActivities': 0,
        'currentLevel': 1,
      };
    }
    
    return jsonDecode(statsJson);
  }

  static Future<void> saveUserStats(Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userStatsKey, jsonEncode(stats));
  }

  static Future<List<Achievement>> checkAndUpdateAchievements() async {
    final achievements = await getAchievements();
    final stats = await getUserStats();
    final newlyCompleted = <Achievement>[];
    
    for (var achievement in achievements) {
      if (achievement.isCompleted) continue;
      
      // 현재 진행도 업데이트
      switch (achievement.type) {
        case AchievementType.doMissions:
          achievement.currentProgress = stats['doMissions'] ?? 0;
          break;
        case AchievementType.daysTracked:
          achievement.currentProgress = stats['daysTracked'] ?? 0;
          break;
        case AchievementType.carbonSaved:
          achievement.currentProgress = stats['carbonSaved'] ?? 0.0;
          break;
        case AchievementType.consecutiveDays:
          achievement.currentProgress = stats['consecutiveDays'] ?? 0;
          break;
        case AchievementType.totalActivities:
          achievement.currentProgress = stats['totalActivities'] ?? 0;
          break;
        case AchievementType.levelReached:
          achievement.currentProgress = stats['currentLevel'] ?? 1;
          break;
      }
      
      // 달성 체크
      if (achievement.currentProgress >= achievement.targetValue) {
        achievement.isCompleted = true;
        newlyCompleted.add(achievement);
      }
    }
    
    if (newlyCompleted.isNotEmpty) {
      await saveAchievements(achievements);
    }
    
    return newlyCompleted;
  }

  static Future<void> updateUserStat(String statName, dynamic value) async {
    final stats = await getUserStats();
    stats[statName] = value;
    await saveUserStats(stats);
  }

  static Future<void> incrementUserStat(String statName, {dynamic amount = 1}) async {
    final stats = await getUserStats();
    stats[statName] = (stats[statName] ?? 0) + amount;
    await saveUserStats(stats);
  }
}