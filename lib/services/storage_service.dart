import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enterprise.dart';
import '../models/flock.dart';

class StorageService {
  static const String _enterprisesKey = 'enterprises';
  static const String _flocksKey = 'flocks';

  // GET ENTERPRISES
  Future<List<Enterprise>> getEnterprises() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_enterprisesKey);
    if (data == null) return [];
    final List decoded = jsonDecode(data);
    return decoded.map((e) => Enterprise.fromJson(e)).toList();
  }

  // SAVE ENTERPRISES - FOR IMPORT
  Future<void> saveEnterprises(List<Enterprise> enterprises) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(enterprises.map((e) => e.toJson()).toList());
    await prefs.setString(_enterprisesKey, data);
  }

  // ADD SINGLE ENTERPRISE
  Future<void> addEnterprise(Enterprise enterprise) async {
    final enterprises = await getEnterprises();
    enterprises.add(enterprise);
    await saveEnterprises(enterprises);
  }

  // GET FLOCKS
  Future<List<Flock>> getFlocks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_flocksKey);
    if (data == null) return [];
    final List decoded = jsonDecode(data);
    return decoded.map((e) => Flock.fromJson(e)).toList();
  }

  // SAVE FLOCKS - FOR IMPORT
  Future<void> saveFlocks(List<Flock> flocks) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(flocks.map((e) => e.toJson()).toList());
    await prefs.setString(_flocksKey, data);
  }

  // ADD SINGLE FLOCK
  Future<void> addFlock(Flock flock) async {
    final flocks = await getFlocks();
    flocks.add(flock);
    await saveFlocks(flocks);
  }

  // CLEAR ALL DATA
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
