import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/log_model.dart';

class LogController {

  final ValueNotifier<List<LogModel>> logsNotifier = ValueNotifier([]);
  final ValueNotifier<List<LogModel>> filteredLogs = ValueNotifier([]);

  static const String _storageKey = 'user_logs_data';

  static const List<String> categories = [
    'Umum',
    'Pekerjaan',
    'Pribadi',
    'Urgent',
  ];


  // CONSTRUCTOR

  LogController() {
    loadFromDisk();
  }


  // ADD

  Future<void> addLog(String title, String desc, String category) async {

    final newLog = LogModel(
      title: title,
      description: desc,
      timestamp: DateTime.now().toString(),
      category: category,
    );

    logsNotifier.value = [...logsNotifier.value, newLog];
    filteredLogs.value = logsNotifier.value;

    await saveToDisk();
  }


  // EDIT

  Future<void> updateLog(int index, String title, String desc, String category) async {

    final allLogs = List<LogModel>.from(logsNotifier.value);

    final originalIndex = allLogs.indexOf(filteredLogs.value[index]);

    allLogs[originalIndex] = LogModel(
      title: title,
      description: desc,
      timestamp: DateTime.now().toString(),
      category: category,
    );

    logsNotifier.value = allLogs;
    filteredLogs.value = allLogs;

    await saveToDisk();
  }


  // DELETE

  Future<void> removeLog(int index) async {

    final allLogs = List<LogModel>.from(logsNotifier.value);

    final target = filteredLogs.value[index];
    allLogs.remove(target);

    logsNotifier.value = allLogs;
    filteredLogs.value = allLogs;

    await saveToDisk();
  }


  // SEARCH

  void searchLog(String query) {

    if (query.isEmpty) {
      filteredLogs.value = logsNotifier.value;
    } else {
      filteredLogs.value = logsNotifier.value
          .where((log) =>
              log.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }


  // SAVE JSON

  Future<void> saveToDisk() async {

    final prefs = await SharedPreferences.getInstance();

    final encodedData = jsonEncode(
      logsNotifier.value.map((e) => e.toMap()).toList(),
    );

    await prefs.setString(_storageKey, encodedData);

    debugPrint("DATA SAVED");
  }


  // LOAD JSON

  Future<void> loadFromDisk() async {

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_storageKey);

    if (data == null) {
      debugPrint("NO DATA FOUND");
      filteredLogs.value = [];
      return;
    }

    final List decoded = jsonDecode(data);

    logsNotifier.value = decoded.map((e) => LogModel.fromMap(e)).toList();
    filteredLogs.value = logsNotifier.value;

    debugPrint("DATA LOADED");
  }
}