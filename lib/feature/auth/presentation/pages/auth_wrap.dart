
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:missionland_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:missionland_app/feature/auth/presentation/pages/sign_in_page.dart';
import 'package:missionland_app/temp/home_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          print( 'Authenticated state detected');
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is Unauthenticated) {
          print('Unauthenticated state detected');
          Navigator.pushReplacementNamed(context, '/sign_in');
        } else if (state is AuthLoading) {
          print('AuthLoading state');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return CircularProgressIndicator();
          }
          return state is Authenticated ? HomePage() : SignInPage();
        },
      ),
    );
  }
}
