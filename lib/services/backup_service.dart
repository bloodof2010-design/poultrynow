import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'storage_service.dart'; // your existing service

class BackupService {
  final StorageService _storage = StorageService();

  // EXPORT - you already have this
  Future<String> exportDataToJson() async {
    //... your existing export code
    return "path/to/backup.json";
  }

  // IMPORT - NEW CODE
  Future<bool> importDataFromFile() async {
    try {
      // 1. Let user pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'csv'],
      );

      if (result == null) return false; // user cancelled

      File file = File(result.files.single.path!);
      String extension = result.files.single.extension!;

      if (extension == 'json') {
        await _importFromJson(file);
      } else if (extension == 'csv') {
        await _importFromCsv(file);
      }

      return true;
    } catch (e) {
      print("Import Error: $e");
      return false;
    }
  }

  Future<void> _importFromJson(File file) async {
    String content = await file.readAsString();
    Map<String, dynamic> data = jsonDecode(content);

    // Example: assuming you saved enterprises as a list
    List enterprises = data['enterprises']?? [];
    await _storage.saveEnterprises(enterprises); // use your save method

    List flocks = data['flocks']?? [];
    await _storage.saveFlocks(flocks);
    
    // Add more tables here
  }

  Future<void> _importFromCsv(File file) async {
    String content = await file.readAsString();
    List<List<dynamic>> csvData = const CsvToListConverter().convert(content);
    
    // csvData[0] = headers, csvData[1...] = rows
    // Convert rows back to objects and save with StorageService
    // Example for enterprises:
    for (int i = 1; i < csvData.length; i++) {
      var row = csvData[i];
      // Map row[0], row[1] etc to your Enterprise model
      // await _storage.addEnterprise(enterprise);
    }
  }
}
