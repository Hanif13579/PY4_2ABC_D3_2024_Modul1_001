import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/log_model.dart';

class LogController {

  final ValueNotifier<List<LogModel>>
      logsNotifier = ValueNotifier([]);

  static const String _storageKey =
      'user_logs_data';


  // CONSTRUCTOR

  LogController() {
    loadFromDisk();
  }


  // ADD

  Future<void> addLog(String title,String desc) async {

    final newLog = LogModel(
      title: title,
      description: desc,
      timestamp:
          DateTime.now().toString(),
    );

    logsNotifier.value = [...logsNotifier.value,newLog,];

    await saveToDisk();
  }


  // EDIT

  Future<void> updateLog(int index,String title,String desc) async {

    final currentLogs =List<LogModel>.from(logsNotifier.value);

    currentLogs[index] = LogModel(
      title: title,
      description: desc,
      timestamp: DateTime.now().toString(),
    );

    logsNotifier.value = currentLogs;

    await saveToDisk();
  }


  // DELETE

  Future<void> removeLog(int index) async {

    final currentLogs = List<LogModel>.from(logsNotifier.value);

    currentLogs.removeAt(index);

    logsNotifier.value = currentLogs;

    await saveToDisk();
  }


  // SAVE JSON

  Future<void> saveToDisk() async {

    final prefs =await SharedPreferences.getInstance();

    final encodedData = jsonEncode(logsNotifier.value.map((e) => e.toMap(),).toList(),);

    await prefs.setString(_storageKey,encodedData);

    debugPrint("DATA SAVED");
  }


  // LOAD JSON

  Future<void> loadFromDisk() async {

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_storageKey);

    if (data == null) {
      debugPrint("NO DATA FOUND");
      return;
    }

    final List decoded = jsonDecode(data);

    logsNotifier.value =decoded.map((e) => LogModel.fromMap(e),).toList();

    debugPrint("DATA LOADED");
  }
}