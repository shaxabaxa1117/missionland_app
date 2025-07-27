import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:missionland_app/feature/posts/presentation/bloc/post_bloc.dart';
import 'package:missionland_app/feature/posts/presentation/pages/add_post_page.dart';
import 'package:missionland_app/feature/island_features/presentation/pages/island_page.dart';
import 'package:missionland_app/app/main_home_page.dart';

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
    const Center(child: Text('Profile Screen', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Time', style: TextStyle(fontSize: 24))),
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
            icon: Icon(Icons.person, size: 24, color: Colors.black54),
            title: 'Profile',
          ),

          TabItem(
            icon: Icon(Icons.access_time, size: 24, color: Colors.black54),
            title: 'Home',
          ),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
