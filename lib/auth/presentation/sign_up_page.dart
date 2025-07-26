import 'package:flutter/material.dart';
import 'package:missionland_app/auth/presentation/components/custom_text_field.dart';
import 'package:missionland_app/auth/presentation/components/green_button.dart';


class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Создай экологичный аккаунт 🌿',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Имя',
                icon: Icons.person,
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
                text: 'Зарегистрироваться',
                onPressed: () {
                  // TODO: логика регистрации
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Уже есть аккаунт? Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
