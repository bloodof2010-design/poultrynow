import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enterprise.dart';
import '../models/flock.dart';

class StorageService {
  // GET
  Future<List<Enterprise>> getEnterprises() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('enterprises');
    if (data == null) return [];
    return (jsonDecode(data) as List).map((e) => Enterprise.fromJson(e)).toList();
  }

  Future<List<Flock>> getFlocks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('flocks');
    if (data == null) return [];
    return (jsonDecode(data) as List).map((e) => Flock.fromJson(e)).toList();
  }

  // SAVE - THESE WERE MISSING
  Future<void> saveEnterprises(List<Enterprise> enterprises) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(enterprises.map((e) => e.toJson()).toList());
    await prefs.setString('enterprises', data);
  }

  Future<void> saveFlocks(List<Flock> flocks) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(flocks.map((e) => e.toJson()).toList());
    await prefs.setString('flocks', data);
  }
}
