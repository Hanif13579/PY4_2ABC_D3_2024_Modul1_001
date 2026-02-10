class CounterController {
  int _counter = 0; // Variabel private (Enkapsulasi)
  int _step = 1;
  List<String> _history = [];

  int get value => _counter; // Getter untuk akses data
  int get step => _step;
  List<String> get history => _history.length > 5
    ?_history.sublist(_history.length - 5)
    :_history;

  void _addHistory(String action, int amount) {
    String timestamp = DateTime.now().toString().substring(11, 19); // Ambil jam:menit:detik
    String message = '$timestamp - $action ${amount > 0 ? amount : ''}';
    _history.add(message);
  }

  void setStep(int newStep) {
    if(newStep > 0){
      _step = newStep;
    }
  }

  void increment() {
    _counter+= _step;
    _addHistory("Tambah", _counter);
  }

  void decrement() { 
    if (_counter >= _step) { 
      _counter -= _step; 
      _addHistory("kurang", _step);
    } else {
      _counter = 0; 
      _addHistory("sisa", _counter);
    }
  }
  void reset(){
    _counter = 0;
    _addHistory("reset", 0);
  }
}