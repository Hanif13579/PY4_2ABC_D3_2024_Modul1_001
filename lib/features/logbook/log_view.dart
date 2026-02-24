import 'package:flutter/material.dart';
import '../models/log_model.dart';
import 'log_controller.dart';
import '../auth/login_view.dart';

class LogView extends StatefulWidget {
  const LogView({super.key});

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {

  final LogController _controller = LogController();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();


  // ADD DIALOG 

  void _showAddLogDialog() {

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text("Tambah Catatan Baru"),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: "Judul Catatan",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: "Isi Deskripsi",
                ),
              ),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),

            ElevatedButton(
              onPressed: () {

                _controller.addLog(_titleController.text,_contentController.text,);

                _titleController.clear();
                _contentController.clear();

                Navigator.pop(context);
              },

              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }


  //EDIT DIALOG

  void _showEditLogDialog(int index, LogModel log) {

    _titleController.text = log.title;
    _contentController.text = log.description;

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text("Edit Catatan"),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: "Judul Catatan",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: "Isi Deskripsi",
                ),
              ),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),

            ElevatedButton(

              onPressed: () {

                _controller.updateLog(
                  index,
                  _titleController.text,
                  _contentController.text,
                );

                _titleController.clear();
                _contentController.clear();

                Navigator.pop(context);
              },

              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }


  // BUILD 

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Logbook"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
              );
            },
          ),
        ],
      ),

      body: ValueListenableBuilder<List<LogModel>>(

        valueListenable: _controller.logsNotifier,

        builder: (context, currentLogs, child) {

          if (currentLogs.isEmpty) {

            return const Center(
              child: Text("Belum ada catatan."),
            );
          }

          return ListView.builder(

            itemCount: currentLogs.length,

            itemBuilder: (context, index) {

              final log = currentLogs[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                child: ListTile(
                  leading: const Icon(Icons.note),
                  title: Text(
                    log.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(log.description,),

                  trailing: Wrap(
                    spacing: 4,

                    children: [

                      // EDIT
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),

                        onPressed: () =>
                            _showEditLogDialog(index, log),
                      ),

                      // DELETE
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),

                        onPressed: () {
                          _controller.removeLog(index);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(

        onPressed: _showAddLogDialog,

        child: const Icon(Icons.add),
      ),
    );
  }
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _controller.logsNotifier.dispose();
    super.dispose();
  }
}