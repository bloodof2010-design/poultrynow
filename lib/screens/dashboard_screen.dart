import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/storage_service.dart';
import '../services/backup_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: FutureBuilder(
        future: StorageService().getUsername(),
        builder: (context, snapshot) {
          final name = snapshot.data ?? 'User';
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text('Hello, $name', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 40),
              ElevatedButton(onPressed: () => context.push('/enterprises'), child: const Text('My Enterprises')),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final path = await BackupService.exportData();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exported to $path')));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                child: const Text('Export Data'),
              ),
            ]),
          );
        }
      ),
    );
  }
}
