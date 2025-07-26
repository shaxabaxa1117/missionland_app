import 'package:flutter/material.dart';

import 'package:missionland_app/auth/presentation/components/custom_text_field.dart';
import 'package:missionland_app/auth/presentation/components/green_button.dart';


class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(flex: 1),
            const Text(
              'Добро пожаловать!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CustomTextField(
              label: 'Email',
              icon: Icons.email,
            ),
            const SizedBox(height: 20),
            const CustomTextField(
              label: 'Пароль',
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 30),
            GreenButton(
              text: 'Войти',
              onPressed: () {
                // TODO: логика входа
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Нет аккаунта? Зарегистрироваться'),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
