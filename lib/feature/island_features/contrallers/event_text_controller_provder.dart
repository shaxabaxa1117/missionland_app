import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider extends ChangeNotifier {
  static const String _lastUpdateKey = 'last_text_update';
  static const String _currentTextSetKey = 'current_text_set';
  
  //! Два набора текстов, которые будут меняться между собой
  final List<List<String>> _textSets = [
    [
      'Beware, tornado is coming!',
      'City\'s daily temperature is rising! ',
      'There is electricity outage in urban areas! ',
      'Trash bins in park area are full! ',
      'Animals in forest area are starving!',
      'Water around the island is getting filled with trash'
    ],
    [
      'Toxic rain damaged the forests!',
      'There is sudden drop  temperatures in mountain areas!',
      'Factories stopped working!',
      'Waste management in urban areas are getting out of hand!',
      'Species of animals are going extinct day by day',
      'Lake near Park is drying up without the river'
    ]
  ];

  List<String> _currentTexts = [];
  DateTime? _lastUpdateDate;

  List<String> get currentTexts => _currentTexts;

  EventProvider() {
    _initializeTexts();
  }

  Future<void> _initializeTexts() async {
    final prefs = await SharedPreferences.getInstance();

    final String? lastUpdateString = prefs.getString(_lastUpdateKey);
    if (lastUpdateString != null) {
      _lastUpdateDate = DateTime.parse(lastUpdateString);
    }


    final int currentSetIndex = prefs.getInt(_currentTextSetKey) ?? 0;
    

    if (_shouldUpdateTexts()) {
      await _updateTexts();
    } else {
      _currentTexts = List.from(_textSets[currentSetIndex]);
    }
    
    notifyListeners();
  }

  bool _shouldUpdateTexts() {
    if (_lastUpdateDate == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(_lastUpdateDate!);
    
    return difference.inDays >= 3;
  }

  Future<void> _updateTexts() async {
    final prefs = await SharedPreferences.getInstance();
    

    final int currentSetIndex = prefs.getInt(_currentTextSetKey) ?? 0;
    

    final int newSetIndex = currentSetIndex == 0 ? 1 : 0;
    _currentTexts = List.from(_textSets[newSetIndex]);
    

    await prefs.setInt(_currentTextSetKey, newSetIndex);
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
    
    _lastUpdateDate = DateTime.now();
  }


  Future<void> forceUpdateTexts() async {
    await _updateTexts();
    notifyListeners();
  }


  Duration? getTimeUntilNextUpdate() {
    if (_lastUpdateDate == null) return null;
    
    final nextUpdateDate = _lastUpdateDate!.add(Duration(days: 3));
    final now = DateTime.now();
    
    if (nextUpdateDate.isAfter(now)) {
      return nextUpdateDate.difference(now);
    }
    
    return Duration.zero;
  }

  
  String getTimeUntilNextUpdateString() {
    final duration = getTimeUntilNextUpdate();
    if (duration == null) return 'Неизвестно';
    
    if (duration.inDays > 0) {
      return '${duration.inDays} дн. ${duration.inHours % 24} ч.';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ч. ${duration.inMinutes % 60} мин.';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} мин.';
    } else {
      return 'Скоро обновится';
    }
  }
}