import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:missionland_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:missionland_app/feature/auth/presentation/pages/auth_wrap.dart';
import 'package:missionland_app/feature/auth/presentation/pages/sign_in_page.dart';
import 'package:missionland_app/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:missionland_app/core/consts/firebase_options.dart';
import 'package:missionland_app/feature/posts/presentation/bloc/post_bloc.dart';
import 'package:missionland_app/feature/posts/presentation/bloc/post_event.dart';
import 'package:missionland_app/feature/videos/presentation/controller/video_provider.dart';
import 'package:missionland_app/injection_container.dart' as di;
import 'package:missionland_app/app/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.initializeDependencies();
  runApp(ChangeNotifierProvider(
    create: (context) => VideoProvider()..loadWatchedVideos(),
    
    child: const EcoApp()));
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
          primaryColor: const Color(0xFF4CAF50), // зелёный
          scaffoldBackgroundColor: const Color(0xFFE8F5E9), // светло-зелёный
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
      
        routes: {
          '/home': (_) => const HomePage(),
          '/sign_in': (_) => const SignInPage(),
          '/sign_up': (_) => const SignUpPage(),
        },
        home: const AuthWrapper(),
      ),
    );
  }
}
