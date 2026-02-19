import 'package:flutter/material.dart';
import 'package:logbook_app_076/features/logbook/counter_controller.dart';
import 'package:logbook_app_076/features/onboarding/onboarding_view.dart';

class CounterView extends StatefulWidget {
  final String username;

  const CounterView({super.key, required this.username});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();
  final TextEditingController _stepController = TextEditingController(text: '1');
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Task 3: Load data dari Shared Preferences
  Future<void> _loadData() async {
    await _controller.init(widget.username);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _stepController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin keluar?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OnboardingView()),
                  (route) => false,
                );
              },
              child: const Text(
                "Ya, Keluar",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleReset() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Counter'),
        content: const Text('Apakah Anda yakin ingin reset ke 0?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _controller.reset());
            },
            child: const Text('Reset', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _updateStep() {
    final newStep = int.tryParse(_stepController.text) ?? 1;
    setState(() {
      _controller.setStep(newStep);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading saat data belum siap
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Logbook: ${widget.username}"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Selamat Datang, ${widget.username}!"),
            const SizedBox(height: 10),
            const Text("Total Hitungan Anda:"),
            Text(
              '${_controller.value}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 30),

            // TextField untuk Step
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Step: '),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _stepController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _updateStep(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tombol Tambah, Kurang, Reset
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _controller.increment()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Tambah'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => setState(() => _controller.decrement()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kurang'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _handleReset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),

            // History
            const Text(
              'Riwayat (5 Terakhir):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _controller.history.isEmpty
                  ? const Center(child: Text('Belum ada aktivitas'))
                  : ListView.builder(
                      itemCount: _controller.history.length,
                      itemBuilder: (context, index) {
                        final entry = _controller.history[index];
                        Color bgColor = Colors.grey.shade100;
                        
                        if (entry.contains('Tambah')) {
                          bgColor = Colors.green.shade100;
                        } else if (entry.contains('Kurang')) {
                          bgColor = Colors.red.shade100;
                        } else if (entry.contains('Reset')) {
                          bgColor = Colors.orange.shade100;
                        }

                        return Card(
                          color: bgColor,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text(entry),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _controller.increment()),
        child: const Icon(Icons.add),
      ),
    );
  }
}