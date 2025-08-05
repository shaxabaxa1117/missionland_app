// restriction_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/restriction_service.dart';

class RestrictionScreen extends StatefulWidget {
  final String appName;
  final double currentEmission;
  final double limit;

  const RestrictionScreen({
    Key? key,
    required this.appName,
    required this.currentEmission,
    required this.limit,
  }) : super(key: key);

  @override
  State<RestrictionScreen> createState() => _RestrictionScreenState();
}

class _RestrictionScreenState extends State<RestrictionScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  static const MethodChannel _channel = MethodChannel('app_restriction');

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
        backgroundColor: Colors.black,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.red[900]!,
                Colors.red[700]!,
                Colors.black,
              ],
            ),
          ),
          child: SafeArea(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 경고 아이콘
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.warning,
            size: 60,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 40),
        
        // 제목
        const Text(
          'CARBON LIMIT REACHED',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 20),
        
        // 앱 이름
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Text(
            widget.appName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        
        const SizedBox(height: 40),
        
        // 배출량 정보
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
          ),
          child: Column(
            children: [
              const Text(
                'Today\'s Carbon Emission',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.currentEmission.toStringAsFixed(1)}g / ${widget.limit.toStringAsFixed(1)}g',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const Text(
                'CO₂',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 50),
        
        // 메시지
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Take a break and help save the planet! 🌍',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: 60),
        
        // 닫기 버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _closeRestriction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _closeRestriction() async {
    // SimpleRestrictionService의 제한 해제
    RestrictionService.dismissRestriction();
    
    // 앱 닫기
    SystemNavigator.pop();
  }
}