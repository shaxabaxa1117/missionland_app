// restriction_service.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:missionland_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:flutter_accessibility_service/accessibility_event.dart';
import 'package:flutter_accessibility_service/constants.dart';
import '../data/app_info_data.dart';
import '../widgets/quote_challenge_screen.dart';

class RestrictionService {
  static const MethodChannel _channel = MethodChannel('app_restriction');
  static bool _isRunning = false;
  static String? _restrictedApp;
  static double? _currentEmission;
  static double? _limit;

  static Future<void> initialize() async {
    try {
      if (!await FlutterAccessibilityService.isAccessibilityPermissionEnabled()) {
        final hasPermission = await FlutterAccessibilityService.requestAccessibilityPermission();
        if (!hasPermission) {
          print('Accessibility permission denied');
          return;
        }
      }

      final flags = await SharedPreferences.getInstance();
      await flags.setBool('isRestricted', false);

      _setupChannel();

      // 앱 메타데이터 로드
      await AppInfoData.loadAppList();

      // 접근성 이벤트 리스너 시작
      _startListening();

      _isRunning = true;
      print('Restriction Service started');
    } catch (e) {
      print('Error initializing service: $e');
    }
  }

  static void _setupChannel() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'checkRestriction':
          if (_restrictedApp != null) {
            return {
              'appName': _restrictedApp,
              'currentEmission': _currentEmission,
              'limit': _limit,
            };
          }
          return null;
        case 'clearRestriction':
          _restrictedApp = null;
          _currentEmission = null;
          _limit = null;
          return true;
        default:
          return null;
      }
    });
  }

  static void _startListening() {
    FlutterAccessibilityService.accessStream.listen((event) async {
      if (event.eventType == EventType.typeWindowStateChanged) {
        final packageName = event.packageName;
        if (packageName != null) {
          await _checkAppRestriction(packageName);
        }
      }
    });
  }

  static Future<void> _checkAppRestriction(String packageName) async {
    final flags = await SharedPreferences.getInstance();

    try {
      // 기존 getAppUsageInfo 함수 사용
      final appInfo = await getAppUsageInfo(packageName);

      if (packageName == 'com.example.missionland_app') {
        final restrictionData = getRestrictionData();
        if (restrictionData != null) {
          flags.setBool('isRestricted', true);
        }
      } else if (appInfo != null) {
        print('App over limit: ${appInfo['displayName']}');
        await _triggerRestriction(appInfo);
      }
    } catch (e) {
      print('Error checking app restriction: $e');
    }
  }

  static Future<Map<String, dynamic>?> getAppUsageInfo(String packageName) async {
    try {
      // daily_usage.json에서 현재 사용량 가져오기
      final dailyData = await AppInfoData.loadDailyUsageData();
      final List<dynamic> apps = dailyData['apps'] ?? [];
      
      double totalUsage = 0.0;
      for (var app in apps) {
        if (app['id'] == packageName) {
          totalUsage = (app['totalUsage'] ?? 0.0).toDouble();
          break;
        }
      }
      
      // 앱 메타데이터 가져오기
      final metadata = AppInfoData.appMetadata[packageName];
      if (metadata == null) {
        return null;
      }
      
      // 배출량 계산
      final double emitRate = metadata.emitRate;
      final double limit = metadata.defaultLimit;
      final double hours = totalUsage / 60;
      final double currentEmission = hours * emitRate;
      
      return {
        'displayName': metadata.displayName,
        'currentEmission': currentEmission,
        'limit': limit,
        'isOverLimit': currentEmission >= limit,
        'totalUsage': totalUsage,
      };
      
    } catch (e) {
      print('Error getting app usage info: $e');
      return null;
    }
  }

  static Future<void> _triggerRestriction(Map<String, dynamic> appInfo) async {
    try {
      // 제한 정보 저장
      _restrictedApp = appInfo['displayName'];
      _currentEmission = appInfo['currentEmission'];
      _limit = appInfo['limit'];

      // Missionland 앱 실행
      await _launchMissionlandApp();
      
    } catch (e) {
      print('Error triggering restriction: $e');
    }
  }

  static Future<void> _launchMissionlandApp() async {
    final flags = await SharedPreferences.getInstance();

    try {
      await flags.setBool('isRestricted', true);

      // 앱 런처를 통해 Missionland 앱 실행
      const launcher = MethodChannel('app_launcher');
      await launcher.invokeMethod('launchApp', {
        'packageName': 'com.example.missionland_app',
      });

      print('Missionland app launched');
      
    } catch (e) {
      print('Error launching Missionland app: $e');
      // 홈 화면으로 이동 (대안)
      await FlutterAccessibilityService.performGlobalAction(
        GlobalAction.globalActionHome
      );
    }
  }

  static bool get isRunning => _isRunning;

  /// 제한 데이터 가져오기 (앱에서 호출)
  static Map<String, dynamic>? getRestrictionData() {
    if (_restrictedApp == null) {
      return null;
    }
    
    return {
      'appName': _restrictedApp,
      'currentEmission': _currentEmission,
      'limit': _limit,
    };
  }

  /// 제한 화면 해제
  static void dismissRestriction() {
    _restrictedApp = null;
    _currentEmission = null;
    _limit = null;
  }
}