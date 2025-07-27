import 'package:flutter/material.dart';

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  // List of image paths and their corresponding routes
  final List<Map<String, String>> imageItems = const [
    {'image': 'assets/top_scroll_images/sad_cloud.png', 'route': '/page10'},
    {'image': 'assets/top_scroll_images/sun.png', 'route': '/page9'},
    {'image': 'assets/top_scroll_images/sad_flower.png', 'route': '/page8'},
    {'image': 'assets/top_scroll_images/water_waste.png', 'route': '/page7'},
    {'image': 'assets/top_scroll_images/rubbish.png', 'route': '/page6'},
    {'image': 'assets/top_scroll_images/lion.png', 'route': '/page5'},
    {'image': 'assets/top_scroll_images/lamp.png', 'route': '/page4'},
    {'image': 'assets/top_scroll_images/sad_cloud.png', 'route': '/page3'},
    {'image': 'assets/top_scroll_images/sad_cloud.png', 'route': '/page2'},
    {'image': 'assets/top_scroll_images/sad_cloud.png', 'route': '/page1'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Home Page'),
        centerTitle: true,
        backgroundColor: Colors.green, // Зеленый цвет для AppBar
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 96, 167, 224),
            height: 60.0,
            // Reduced height for smaller images
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35.0,
                  ), // Reduced padding
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, imageItems[index]['route']!);
                    },
                    child: Container(
                      width: 60.0, // Smaller image size
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          6.0,
                        ), // Slightly smaller border radius
                        image: DecorationImage(
                          image: AssetImage(imageItems[index]['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Welcome to the Main Home Page!',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
