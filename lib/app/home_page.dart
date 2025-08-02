import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:missionland_app/feature/posts/presentation/pages/add_post_page.dart';
import 'package:missionland_app/feature/island_features/presentation/pages/island_page.dart';
import 'package:missionland_app/feature/posts/presentation/pages/main_home_page.dart';
import 'package:missionland_app/feature/screen_time/screen_time_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Список виджетов для отображения на разных вкладках
  final List<Widget> _pages = [
    const MainHomePage(),
    const IslandPage(),
    const AddPostPage(),
    ScreenTimeScreen(), //! for further development
    const Center(child: Text('Profile screen', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: _pages[_selectedIndex], // Отображаем выбранную страницу
      bottomNavigationBar: ConvexAppBar(
        style:
            TabStyle
                .reactCircle, // Стиль с круглым эффектом, поддерживает четное число вкладок
        backgroundColor: Colors.green, // Зеленый фон
        activeColor: Colors.greenAccent, // Зеленый акцент для активной вкладки
        items: [
          TabItem(
            icon: Icon(Icons.home, size: 24, color: Colors.black54),
            title: 'Home',
          ),
          TabItem(
            icon: Icon(Icons.landscape, size: 24, color: Colors.black54),
            title: 'Island',
          ),
          TabItem(
            icon: Icon(Icons.add, size: 24, color: Colors.black54),
            title: 'Add',
          ),
          TabItem(
            icon: Icon(Icons.screen_lock_landscape, size: 24, color: Colors.black54),
            title: 'Screen Time',
          ),
          TabItem(
            icon: Icon(Icons.person, size: 24, color: Colors.black54),
            title: 'Profile',
          ),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
