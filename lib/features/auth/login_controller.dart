class LoginController {
  // Task 2.1
  final Map<String, String> _users = {
    'admin': '123',
    'hanif': 'gktaulupa',
    'finah': 'udahgklupa',
  };

  // Task 2.3: Batas percobaan login
  int _failedAttempts = 0;
  DateTime? _lockUntil;

  bool login(String username, String password) {
    if (_lockUntil != null && DateTime.now().isBefore(_lockUntil!)) {
      return false;
    }

    if (_users[username] == password) {
      _failedAttempts = 0; // Reset kalau berhasil
      _lockUntil = null;
      return true;
    } else {
      _failedAttempts++;
      if (_failedAttempts >= 3) {
        _lockUntil = DateTime.now().add(const Duration(seconds: 10));
      }
      return false;
    }
  }

  bool isLocked() {
    if (_lockUntil == null) return false;
    return DateTime.now().isBefore(_lockUntil!);
  }

  // Sisa waktu kunci (dalam detik)
  int getRemainingLockTime() {
    if (_lockUntil == null) return 0;
    int remaining = _lockUntil!.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  // Sisa percobaan
  int getRemainingAttempts() {
    return 3 - _failedAttempts;
  }
}