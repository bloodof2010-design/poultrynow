import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'storage_service.dart';
import '../models/enterprise.dart';
import '../models/flock.dart';

class BackupService {
  final StorageService _storage = StorageService();

  // STATIC so you can call BackupService.exportData() from UI
  static Future<String> exportData() async {
    final service = BackupService();
    return await service._exportToJson();
  }

  static Future<bool> importData() async {
    final service = BackupService();
    return await service._importFromFile();
  }

  // EXPORT TO JSON
  Future<String> _exportToJson() async {
    final enterprises = await _storage.getEnterprises();
    final flocks = await _storage.getFlocks();

    Map<String, dynamic> backup = {
      'version': '1.0.40',
      'exported_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      'enterprises': enterprises.map((e) => e.toJson()).toList(),
      'flocks': flocks.map((e) => e.toJson()).toList(),
    };

    final jsonString = jsonEncode(backup);
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'poultrynow_backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json';
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(jsonString);
    return file.path;
  }

  // IMPORT FROM JSON
  Future<bool> _importFromFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: 'Select PoultryNow Backup File',
      );

      if (result == null) return false; // user cancelled

      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      Map<String, dynamic> data = jsonDecode(content);

      // Parse and save
      List<Enterprise> enterprises = [];
      if (data['enterprises'] != null) {
        enterprises = (data['enterprises'] as List)
            .map((e) => Enterprise.fromJson(e)).toList();
      }

      List<Flock> flocks = [];
      if (data['flocks'] != null) {
        flocks = (data['flocks'] as List)
            .map((e) => Flock.fromJson(e)).toList();
      }

      // WARNING: This overwrites existing data
      await _storage.saveEnterprises(enterprises);
      await _storage.saveFlocks(flocks);

      return true;
    } catch (e) {
      print("Import Error: $e");
      return false;
    }
  }
}
