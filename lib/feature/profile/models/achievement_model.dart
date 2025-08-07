// models/achievement.dart
import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  IconData icon;
  Color color;
  final int pointReward;
  final AchievementType type;
  final dynamic targetValue;
  bool isCompleted;
  dynamic currentProgress;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.pointReward,
    required this.type,
    required this.targetValue,
    this.isCompleted = false,
    this.currentProgress = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pointReward': pointReward,
      'type': type.toString(),
      'targetValue': targetValue,
      'isCompleted': isCompleted,
      'currentProgress': currentProgress,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: Icons.star,
      color: Colors.blue,
      pointReward: json['pointReward'],
      type: AchievementType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      targetValue: json['targetValue'],
      isCompleted: json['isCompleted'] ?? false,
      currentProgress: json['currentProgress'] ?? 0,
    );
  }

  double get progressPercentage {
    if (targetValue == 0) return 0.0;
    return (currentProgress / targetValue).clamp(0.0, 1.0);
  }
}

enum AchievementType {
  doMissions,
  daysTracked,
  carbonSaved,
  consecutiveDays,
  totalActivities,
  levelReached,
}