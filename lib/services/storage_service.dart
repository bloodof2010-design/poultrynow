import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enterprise.dart';

class StorageService {
  static const _keyUsername = 'username';
  static const _keyEnterprises = 'enterprises';

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
  }

  Future<List<Enterprise>> getEnterprises() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyEnterprises);
    if (data == null) return [];
    final List jsonList = jsonDecode(data);
    return jsonList.map((e) => Enterprise.fromJson(e)).toList();
  }

  Future<void> saveEnterprise(Enterprise enterprise) async {
    final enterprises = await getEnterprises();
    enterprises.add(enterprise);
    await _saveAll(enterprises);
  }

  Future<void> deleteEnterprise(String id) async {
    final enterprises = await getEnterprises();
    enterprises.removeWhere((e) => e.id == id);
    await _saveAll(enterprises);
  }

  Future<Map<String, dynamic>> getAllDataForBackup() async {
    return {'enterprises': (await getEnterprises()).map((e) => e.toJson()).toList()};
  }

  Future<void> importData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data['enterprises'] != null) {
      await prefs.setString(_keyEnterprises, jsonEncode(data['enterprises']));
    }
  }

  Future<void> _saveAll(List<Enterprise> enterprises) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEnterprises, jsonEncode(enterprises.map((e) => e.toJson()).toList()));
  }
}
