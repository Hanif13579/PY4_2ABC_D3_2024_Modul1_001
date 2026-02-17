import 'package:flutter/material.dart';
import 'package:logbook_app_076/features/auth/login_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int step = 1;

  void _handleNext() {
    if (step < 3) {
      setState(() {
        step++;
      });
    } else {
      // Kalau step sudah > 3, pindah ke Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Halaman Onboarding',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/onboarding$step.png',
              height: 250,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _handleNext,
              child: const Text('Lanjut'),
            ),
          ],
        ),
      ),
    );
  }
}