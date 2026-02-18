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
          content: const Text(
              "Apakah Anda yakin? Data yang belum disimpan mungkin akan hilang."),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Counter telah di-reset!')),
              );
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

          
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Step: ', style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _stepController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    ),
                    onChanged: (_) => _updateStep(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Task 1 : Tombol Tambah, Kurang, Reset
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => setState(() => _controller.increment()),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _controller.decrement()),
                  icon: const Icon(Icons.remove),
                  label: const Text('Kurang'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _handleReset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 2),

            // Task 2: History Logger 5 terakhir
            const Text(
              'Riwayat Aktivitas (5 Terakhir):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // ListView 
            Expanded(
              child: _controller.history.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada aktivitas',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _controller.history.length,
                      itemBuilder: (context, index) {
                        final entry = _controller.history[index];
                        
                        // Homework: warna berbeda untuk Tambah warna hijau dan Kurang warna merah
                        Color tileColor = Colors.grey.shade100;
                        if (entry.contains('Tambah')) {
                          tileColor = Colors.green.shade50;
                        } else if (entry.contains('kurang')) {
                          tileColor = Colors.red.shade50;
                        } else if (entry.contains('reset')) {
                          tileColor = Colors.orange.shade50;
                        }

                        return Card(
                          color: tileColor,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.indigo,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              entry,
                              style: const TextStyle(fontSize: 14),
                            ),
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