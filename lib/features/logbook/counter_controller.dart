import 'package:shared_preferences/shared_preferences.dart';

class CounterController {
  int _counter = 0;
  int _step = 1;
  List<String> _history = [];
  String _username = '';

  int get value => _counter;
  int get step => _step;
  List<String> get history => _history.length > 5
      ? _history.sublist(_history.length - 5)
      : _history;

  // Task 3: Init untuk load data dari Shared Preferences
  Future<void> init(String username) async {
    _username = username;
    await _loadData();
  }

  void _addHistory(String action, int amount) {
    String timestamp = DateTime.now().toString().substring(11, 19);
    String message = '$timestamp - $action ${amount > 0 ? amount : ''}';
    _history.add(message);
    _saveData(); 
  }

  void setStep(int newStep) {
    if (newStep > 0) {
      _step = newStep;
    }
  }

  void increment() {
    _counter += _step;
    _addHistory("Tambah", _step);
  }

  void decrement() {
    if (_counter >= _step) {
      _counter -= _step;
      _addHistory("Kurang", _step);
    } else {
      _counter = 0;
      _addHistory("Sisa", _counter);
    }
  }

  void reset() {
    _counter = 0;
    _addHistory("Reset", 0);
  }

  // Task 3: Simpan data ke Shared Preferences (per user)
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter_$_username', _counter);
    await prefs.setStringList('history_$_username', _history);
  }

  // Task 3: Load data dari Shared Preferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('counter_$_username') ?? 0;
    _history = prefs.getStringList('history_$_username') ?? [];
  }
}