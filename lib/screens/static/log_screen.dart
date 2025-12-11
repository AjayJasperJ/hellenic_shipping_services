import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/utils/logger_service.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  List<Map<String, dynamic>> logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final rawLogs = await LoggerService.readLogs();

    final lines = rawLogs
        .split("\n")
        .where((e) => e.trim().isNotEmpty)
        .toList();

    List<Map<String, dynamic>> parsed = [];

    for (var line in lines) {
      try {
        parsed.add(jsonDecode(line));
      } catch (_) {
        parsed.add({
          "timestamp": DateTime.now().toIso8601String(),
          "category": "unknown",
          "action": line,
        });
      }
    }

    setState(() {
      logs = parsed.reversed.toList(); // newest first
    });
  }

  Color _categoryColor(String c) {
    switch (c) {
      case "error":
        return Colors.redAccent;
      case "api":
        return Colors.blueAccent;
      case "ui":
        return Colors.green;
      case "legacy":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logger"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await LoggerService.clearLogs();
              _loadLogs();
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _loadLogs,
        child: logs.isEmpty
            ? const Center(child: Text("No logs found"))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: logs.length,
                itemBuilder: (_, index) {
                  final log = logs[index];

                  final category = log["category"] ?? "unknown";
                  final time = log["timestamp"] ?? "";

                  return Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _categoryColor(category)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _categoryColor(category),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            category.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Timestamp
                        Text(
                          time,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Show all fields dynamically
                        ...log.entries
                            .where(
                              (entry) =>
                                  entry.key != "timestamp" &&
                                  entry.key != "category",
                            )
                            .map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${entry.key}: ",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        entry.value.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
