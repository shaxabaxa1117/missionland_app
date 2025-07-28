import 'package:flutter/material.dart';
import 'package:missionland_app/feature/island_features/contrallers/event_text_controller_provder.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'events_drawer.dart';


class IslandPage extends StatefulWidget {
  const IslandPage({super.key});

  @override
  _IslandPageState createState() => _IslandPageState();
}

class _IslandPageState extends State<IslandPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showImages = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showImages = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ChangeNotifierProvider(
        create: (context) => EventProvider(),
        child: EventsDrawer()), // Используем новый custom drawer
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Events',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        title: Text('Your Eco Island'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_images/background_island.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Center(
              child: Text(
                '',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (_showImages)
            Stack(
              children: [
                Positioned(
                  bottom: 350,
                  left: 180,
                  child: Image.asset(
                    'assets/island_assets/bin_words.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  bottom: 320,
                  left: 240,
                  child: Image.asset(
                    'assets/island_assets/bin.png',
                    width: 200,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}