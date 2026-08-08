import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'storage_service.dart';
import '../models/enterprise.dart';
import '../models/flock.dart'; // This file must exist now

class BackupService {
  final StorageService _storage = StorageService();

  static Future<String> exportData() async {
    final service = BackupService();
    return await service._exportToJson();
  }

  static Future<bool> importData() async {
    final service = BackupService();
    return await service._importFromFile();
  }

  Future<String> _exportToJson() async {
    final enterprises = await _storage.getEnterprises();
    final flocks = await _storage.getFlocks();

    Map<String, dynamic> backup = {
      'version': '1.0.47',
      'exported_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      'enterprises': enterprises.map((e) => e.toJson()).toList(),
      'flocks': flocks.map((f) => f.toJson()).toList(), // f not e to avoid confusion
    };

    final jsonString = jsonEncode(backup);
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'poultrynow_backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json';
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(jsonString);
    return file.path;
  }

  Future<bool> _importFromFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null) return false;

      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      Map<String, dynamic> data = jsonDecode(content);

      List<Enterprise> enterprises = [];
      if (data['enterprises'] != null) {
        enterprises = (data['enterprises'] as List)
            .map((e) => Enterprise.fromJson(e)).toList();
      }

      List<Flock> flocks = [];
      if (data['flocks'] != null) {
        flocks = (data['flocks'] as List)
            .map((f) => Flock.fromJson(f)).toList();
      }

      await _storage.saveEnterprises(enterprises);
      await _storage.saveFlocks(flocks);
      return true;
    } catch (e) {
      print("Import Error: $e");
      return false;
    }
  }
}
