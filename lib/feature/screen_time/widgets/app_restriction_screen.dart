// app_restriction_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/restriction_service.dart';
import 'package:missionland_app/app/home_page.dart';

class AppRestrictionScreen extends StatefulWidget {
  final String appName;
  final double currentEmission;
  final double limit;

  const AppRestrictionScreen({
    Key? key,
    required this.appName,
    required this.currentEmission,
    required this.limit,
  }) : super(key: key);

  @override
  State<AppRestrictionScreen> createState() => _AppRestrictionScreenState();
}

class _AppRestrictionScreenState extends State<AppRestrictionScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // 전체화면 설정
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    // 애니메이션 설정
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    // 시스템 UI 복원
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 뒤로가기 차단
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  
                  // Title
                  Text(
                    'Sorry!',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                
                  Text(
                    '${widget.appName} is blocked\nfor today',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 32),
                  
                  // Subtitle with CO2 info
                  Text(
                    'You have exceeded your daily carbon limit\non ${widget.appName}.\nTry again tomorrow when your limit resets.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Carbon usage info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Carbon Usage on this app',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${widget.currentEmission.toStringAsFixed(1)} g CO₂',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          ' / ${widget.limit.toStringAsFixed(1)} g CO₂',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Return button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _returnToHome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Return to Home',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _returnToHome() async {
    // 제한 정보 저장 (선택사항)
    RestrictionService.dismissRestriction();

    // 시스템 UI 복원
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // 홈 화면으로 이동
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage())
    );
  }
}