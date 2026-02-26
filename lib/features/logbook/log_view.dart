import 'package:flutter/material.dart';
import '../models/log_model.dart';
import 'log_controller.dart';

import '../onboarding/onboarding_view.dart';

class LogView extends StatefulWidget {
  const LogView({super.key});

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {

  final LogController _controller = LogController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = LogController.categories.first;


  // CATEGORY COLOR

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Pekerjaan':
        return Colors.blue.shade100;
      case 'Pribadi':
        return Colors.green.shade100;
      case 'Urgent':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getCategoryBorderColor(String category) {
    switch (category) {
      case 'Pekerjaan':
        return Colors.blue.shade400;
      case 'Pribadi':
        return Colors.green.shade400;
      case 'Urgent':
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }


  // ADD DIALOG

  void _showAddLogDialog() {

    _selectedCategory = LogController.categories.first;

    showDialog(
      context: context,
      builder: (context) {

        return StatefulBuilder(
          builder: (context, setDialogState) {

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

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: "Kategori",
                    ),
                    items: LogController.categories
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        _selectedCategory = val!;
                      });
                    },
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

                    if (_titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Judul tidak boleh kosong!")),
                      );
                      return;
                    }

                    _controller.addLog(
                      _titleController.text,
                      _contentController.text,
                      _selectedCategory,
                    );

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
      },
    );
  }


  // EDIT DIALOG

  void _showEditLogDialog(int index, LogModel log) {

    _titleController.text = log.title;
    _contentController.text = log.description;
    _selectedCategory = log.category;

    showDialog(
      context: context,
      builder: (context) {

        return StatefulBuilder(
          builder: (context, setDialogState) {

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

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: "Kategori",
                    ),
                    items: LogController.categories
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        _selectedCategory = val!;
                      });
                    },
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
                      _selectedCategory,
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
            onPressed: _handleLogout,
          ),
        ],
      ),

      body: Column(
        children: [

          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => _controller.searchLog(val),
              decoration: const InputDecoration(
                labelText: "Cari Catatan...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: ValueListenableBuilder<List<LogModel>>(

              valueListenable: _controller.filteredLogs,

              builder: (context, currentLogs, child) {

                if (currentLogs.isEmpty) {
                  return _buildEmptyState();
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
                      color: _getCategoryColor(log.category),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: _getCategoryBorderColor(log.category),
                          width: 1.2,
                        ),
                      ),

                      child: ListTile(
                        leading: const Icon(Icons.note),

                        title: Text(
                          log.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(log.description),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getCategoryBorderColor(log.category),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                log.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        trailing: Wrap(
                          spacing: 4,

                          children: [

                            // EDIT
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () => _showEditLogDialog(index, log),
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
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(

        onPressed: _showAddLogDialog,

        child: const Icon(Icons.add),
      ),
    );
  }


  // EMPTY STATE

  Widget _buildEmptyState() {

    final isSearching = _searchController.text.isNotEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            isSearching ? Icons.search_off : Icons.note_alt_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 16),

          Text(
            isSearching
                ? "Catatan tidak ditemukan"
                : "Belum ada catatan nih!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            isSearching
                ? "Coba kata kunci yang lain"
                : "Tap tombol + untuk mulai mencatat",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }


  // LOGOUT

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


  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _searchController.dispose();
    _controller.logsNotifier.dispose();
    _controller.filteredLogs.dispose();
    super.dispose();
  }
}