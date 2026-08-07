import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/enterprise.dart';
import '../services/storage_service.dart';

class AddEnterpriseScreen extends StatefulWidget {
  const AddEnterpriseScreen({super.key});
  @override
  State<AddEnterpriseScreen> createState() => _AddEnterpriseScreenState();
}

class _AddEnterpriseScreenState extends State<AddEnterpriseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _type = 'Hens';
  final _storage = StorageService();

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final enterprise = Enterprise(
        name: _nameCtrl.text,
        type: _type,
        notes: _notesCtrl.text,
        dateCreated: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      await _storage.saveEnterprise(enterprise);
      if(mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Enterprise')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Enterprise Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
            DropdownButtonFormField<String>(value: _type, items: ['Hens','Cattle'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => _type = v!)),
            TextFormField(controller: _notesCtrl, decoration: const InputDecoration(labelText: 'Notes')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Save'))
          ]),
        ),
      ),
    );
  }
}
