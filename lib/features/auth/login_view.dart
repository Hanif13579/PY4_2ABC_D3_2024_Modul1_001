import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logbook_app_076/features/auth/login_controller.dart';
import '../logbook/log_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  // Task 2.4: Show/Hide Password
  bool _obscurePassword = true;
  
  // Timer untuk update countdown
  Timer? _timer;
  int _countdown = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _countdown = _controller.getRemainingLockTime();
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _countdown = _controller.getRemainingLockTime();
        if (_countdown <= 0) {
          timer.cancel();
        }
      });
    });
  }

  void _handleLogin() {
    String user = _userController.text;
    String pass = _passController.text;

    // Task 2.2
    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan Password tidak boleh kosong!")),
      );
      return;
    }

    if (_controller.isLocked()) {
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terlalu banyak percobaan! Tunggu $_countdown detik."),
        ),
      );
      return;
    }

    bool isSuccess = _controller.login(user, pass);

    if (isSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LogView(),
        ),
      );
    } else {
      int remaining = _controller.getRemainingAttempts();
      
      if (_controller.isLocked()) {
        _startCountdown();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Terlalu banyak percobaan! Akun terkunci 10 detik."),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login gagal! Sisa percobaan: $remaining kali"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonDisabled = _controller.isLocked();

    return Scaffold(
      appBar: AppBar(title: const Text("Login Gatekeeper")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField Username
            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _passController,
              obscureText: _obscurePassword, 
              decoration: InputDecoration(
                labelText: "Password",
                border: const OutlineInputBorder(),
                // Task 2.4
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Info akun demo
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Akun demo:\nadmin/123 | hanif/gktaulupa | finah/udahgklupa',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
            
            // Tombol Login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonDisabled ? null : _handleLogin,
                child: isButtonDisabled
                    ? Text('Tunggu $_countdown detik...')
                    : const Text("Masuk"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}