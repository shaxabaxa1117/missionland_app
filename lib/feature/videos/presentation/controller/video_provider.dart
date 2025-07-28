// providers/video_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoProvider extends ChangeNotifier {
  static const String _watchedVideosKey = 'watched_videos';

  // Тексты для каждого видео по индексу
  final Map<int, String> _videoTexts = {
    1: 'Mission: Plant a Breath Buddy Task: Plant a small plant indoors or outdoors and share the picture of your new friend on your posts. ',
    2: '''Mission: Heatless Meal Day 
    • Make or eat at least one no-cook meal today. 
    • Take a photo of your “climate-friendly” meal.''',
    3: '''Mission: Tree Talk 
• Write and post a  “thank you letter” to a tree near your home/school, if you can research about tree type and its history. 
• Share a picture of your note and the tree!''',
    4: '''Mission: Clean Stream Dream 
• Clean a nearby area: pick up 10+ pieces of litter (focus on plastic). 
• Use gloves and be safe! Upload a “before & after” photo.''',
    5: '''Mission: Species Tracker 
• Spend 20 minutes looking for insects or birds and log at least 3 species on posts''',
    6: '''Mission: Reuse Relay 
• Find and repurpose 3 old items (like jars, shirts, boxes). 
•          Before/After photo challenge in the app!''',
    7: '''Electricity 
Mission: Energy Time Traveler 
• Pretend you're a 1920s kid with no electricity.
o Do chores by hand for 10 minutes (fold laundry, sweep, clean desk). 
o Then do 15 “energy-free” squats. 
• Bonus: Don’t use your phone for 30 minutes today!''',
    8: '''Task: Map 6 air polluted places in your neighborhood such as car traffic zones, factory zones, and 
create small cards where you give ancient example to these sites. Go for search of these places on 
your foot or bike. ''',
    9: '''Task: Have one day eco-friendly trips, go only on foot or bike to your destination. If not possible, use 
public transport for one day. ''',
    10: '''Task: Write a short post or record a 30-sec message about air pollution. Share with 1+ friend or 
online. Upload to the app’s Create Post feature and see what others have to say about it. ''',
  };

  Set<int> _watchedVideos = <int>{};

  // Получить текст для видео
  String getVideoText(int videoIndex) {
    return _videoTexts[videoIndex] ?? 'Текст для видео $videoIndex';
  }

  // Проверить, просмотрено ли видео
  bool isVideoWatched(int videoIndex) {
    return _watchedVideos.contains(videoIndex);
  }

  // Переключить статус просмотра
  Future<void> toggleVideoWatched(int videoIndex) async {
    if (_watchedVideos.contains(videoIndex)) {
      _watchedVideos.remove(videoIndex);
    } else {
      _watchedVideos.add(videoIndex);
    }
    await _saveWatchedVideos();
    notifyListeners();
  }

  // Загрузить сохраненные данные
  Future<void> loadWatchedVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final watchedList = prefs.getStringList(_watchedVideosKey) ?? [];
    _watchedVideos = watchedList.map((e) => int.parse(e)).toSet();
    notifyListeners();
  }

  // Сохранить данные
  Future<void> _saveWatchedVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final watchedList = _watchedVideos.map((e) => e.toString()).toList();
    await prefs.setStringList(_watchedVideosKey, watchedList);
  }
}
