import 'package:flutter/material.dart';

class IslandPage extends StatelessWidget {
  const IslandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Home Page'),
        centerTitle: true,
        backgroundColor: Colors.green, // Зеленый цвет для AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/background_images/background_island.png',
            ), // Путь к вашему фоновому изображению
            fit: BoxFit.cover, // Изображение растягивается на весь экран
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(
                0.3,
              ), // Полупрозрачный слой для лучшей читаемости
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Text(
            'Welcome to Main Home Page',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white, // Белый текст для контраста с фоном
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
