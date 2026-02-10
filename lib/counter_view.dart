import 'package:flutter/material.dart';
import 'counter_controller.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});
  
  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();
  final TextEditingController _stepController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LogBook: History Logger"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text("Total Hitungan:", style: TextStyle(fontSize: 18)),
              Text(
                '${_controller.value}',
                style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              
              // Input Step
              const Text("Atur Step (Langkah):", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              SizedBox(
                width: 150,
                child: TextField(
                  controller: _stepController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan step',
                  ),
                  onChanged: (value) {
                    int? newStep = int.tryParse(value);
                    if (newStep != null && newStep > 0) {
                      setState(() {
                        _controller.setStep(newStep);
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Step saat ini: ${_controller.step}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              
              const SizedBox(height: 30),
              
              // Tombol-tombol
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () => setState(() => _controller.decrement()),
                    heroTag: 'btn_minus',
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: _showResetDialog,
                    heroTag: 'btn_reset',
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.refresh),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: () => setState(() => _controller.increment()),
                    heroTag: 'btn_plus',
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // History Logger
              const Divider(thickness: 2),
              const Text(
                "📜 Riwayat Aktivitas (5 Terakhir)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _controller.history.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Belum ada aktivitas",
                          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                      )
                    : Column(
                        children: _controller.history.reversed.map((item) {
                          Color bgColor = Colors.grey.shade200;
                          if (item.contains('Tambah')) {
                            bgColor = Colors.green.shade100;
                          } else if (item.contains('Kurang')) {
                            bgColor = Colors.red.shade100;
                          } else if (item.contains('Reset')) {
                            bgColor = Colors.orange.shade100;
                          }
                          
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  item.contains('Tambah') 
                                      ? Icons.arrow_upward 
                                      : item.contains('Kurang')
                                          ? Icons.arrow_downward
                                          : Icons.refresh,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 30),
              SizedBox(width: 10),
              Text('Konfirmasi Reset'),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin mereset counter ke 0?\n\nData riwayat akan tetap tersimpan.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'BATAL',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _controller.reset();
                });
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Counter berhasil direset!'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                'YA, RESET',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}