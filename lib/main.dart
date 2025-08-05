import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:missionland_app/feature/auth/presentation/pages/auth_wrap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:missionland_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:missionland_app/feature/auth/presentation/pages/sign_in_page.dart';
import 'package:missionland_app/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:missionland_app/core/consts/firebase_options.dart';
import 'package:missionland_app/feature/posts/presentation/bloc/post_bloc.dart';
import 'package:missionland_app/feature/posts/presentation/bloc/post_event.dart';
import 'package:missionland_app/feature/videos/presentation/controller/video_provider.dart';
import 'package:missionland_app/injection_container.dart' as di;
import 'package:missionland_app/app/home_page.dart';
import 'feature/screen_time/services/restriction_service.dart';
import 'feature/screen_time/widgets/restrict_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.initializeDependencies();
  
  try {
    await RestrictionService.initialize();
    print('Restriction Service initialized successfully');
  } catch (e) {
    print('Error initializing Restriction Service: $e');
  }
  
  runApp(ChangeNotifierProvider(
    create: (context) => VideoProvider()..loadWatchedVideos(),
    child: const EcoApp()
  ));
}

class EcoApp extends StatelessWidget {
  const EcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl.get<AuthBloc>()..add(AuthCheckEvent()),
        ),
        BlocProvider(
          create: (context) => di.sl<PostBloc>()..add(LoadPostsEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Eco App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF4CAF50),
          scaffoldBackgroundColor: const Color(0xFFE8F5E9),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        routes: {
          '/home': (_) => const HomePage(),
          '/sign_in': (_) => const SignInPage(),
          '/sign_up': (_) => const SignUpPage()
        },
        home: const AppInitializer(),
      ),
    );
  }
}

// 
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> with WidgetsBindingObserver {
  bool _isRestrictionScreenShowing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkRestrictionStatus();
    print('init');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    print('dispose');
  }

  // 포그라운드 검사
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      _checkRestrictionStatus();
    }
  }

  Future<void> _checkRestrictionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isRestricted = prefs.getBool('isRestricted') ?? false;
    print(isRestricted);

    if (isRestricted && !_isRestrictionScreenShowing && mounted) {
      _isRestrictionScreenShowing = true;

      // 플래그 초기화
      await prefs.setBool('isRestricted', false);

      final restrictionData = RestrictionService.getRestrictionData();

      if (restrictionData != null && mounted) {
        // 제한 화면 표시
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RestrictionScreen(
              appName: restrictionData['appName'] ?? 'Unknown App',
              currentEmission: (restrictionData['currentEmission'] ?? 0.0).toDouble(),
              limit: (restrictionData['limit'] ?? 0.0).toDouble(),
            ),
          ),
        );
        // 제한 화면에서 돌아오면 다시 검사 가능하게 설정
        _isRestrictionScreenShowing = false;
        return;
      }
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}