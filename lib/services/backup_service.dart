import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'storage_service.dart';

class BackupService {
  static final _storage = StorageService();

  static Future<String> exportData() async {
    final data = await _storage.getAllDataForBackup();
    final jsonString = jsonEncode(data);
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    final fileName = 'poultrynow_backup_$date.json';

    Directory? dir = await getDownloadsDirectory();
    dir ??= await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(jsonString);
    return file.path;
  }

  static Future<void> importData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final data = jsonDecode(content);
      await _storage.importData(data);
    } else {
      throw Exception('No file selected');
    }
  }
}
