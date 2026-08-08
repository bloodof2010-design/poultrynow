import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'storage_service.dart';
import '../models/enterprise.dart';
import '../models/flock.dart';

class BackupService {
  final StorageService _storage = StorageService();

  // STATIC METHODS so you can call BackupService.exportData()
  static Future<String> exportData() async {
    final service = BackupService();
    return await service._exportToJson();
  }

  static Future<bool> importData() async {
    final service = BackupService();
    return await service._importFromFile();
  }

  // EXPORT
  Future<String> _exportToJson() async {
    final enterprises = await _storage.getEnterprises();
    final flocks = await _storage.getFlocks();

    Map<String, dynamic> data = {
      'enterprises': enterprises.map((e) => e.toJson()).toList(),
      'flocks': flocks.map((e) => e.toJson()).toList(),
      'exported_at': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
    };

    final jsonString = jsonEncode(data);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/poultrynow_backup.json');
    await file.writeAsString(jsonString);
    return file.path;
  }

  // IMPORT
  Future<bool> _importFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'csv'],
    );
    if (result == null) return false;

    File file = File(result.files.single.path!);
    if (result.files.single.extension == 'json') {
      await _importFromJson(file);
    }
    return true;
  }

  Future<void> _importFromJson(File file) async {
    String content = await file.readAsString();
    Map<String, dynamic> data = jsonDecode(content);

    List<Enterprise> enterprises = (data['enterprises'] as List)
        .map((e) => Enterprise.fromJson(e)).toList();
    List<Flock> flocks = (data['flocks'] as List)
        .map((e) => Flock.fromJson(e)).toList();

    await _storage.saveEnterprises(enterprises);
    await _storage.saveFlocks(flocks);
  }
}
