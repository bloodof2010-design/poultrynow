import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/enterprise.dart';
import '../services/storage_service.dart';
import '../services/backup_service.dart';

class EnterprisesScreen extends StatefulWidget {
  const EnterprisesScreen({super.key});
  @override
  State<EnterprisesScreen> createState() => _EnterprisesScreenState();
}

class _EnterprisesScreenState extends State<EnterprisesScreen> {
  final _storage = StorageService();
  late Future<List<Enterprise>> _future;

  @override
  void initState() {
    super.initState();
    _future = _storage.getEnterprises();
  }

  void _refresh() => setState(() => _future = _storage.getEnterprises());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Enterprises')),
      body: Column(children: [
        Expanded(
          child: FutureBuilder<List<Enterprise>>(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final enterprises = snapshot.data!;
              if (enterprises.isEmpty) return const Center(child: Text('No enterprises yet'));
              return ListView(
                children: enterprises.map((e) => Dismissible(
                  key: Key(e.id),
                  background: Container(color: Colors.red),
                  onDismissed: (_) async {
                    await _storage.deleteEnterprise(e.id);
                    _refresh();
                  },
                  child: ListTile(title: Text(e.name), subtitle: Text('${e.type} - ${e.notes}')),
                )).toList(),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () async {
              try {
                await BackupService.importData();
                _refresh();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Import Successful')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Import Data'),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add_enterprise').then((_) => _refresh()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
