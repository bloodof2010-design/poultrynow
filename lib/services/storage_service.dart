import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enterprise.dart';
import '../models/flock.dart'; // This file must exist now

class StorageService {
  static const String _enterprisesKey = 'enterprises';
  static const String _flocksKey = 'flocks';
  static const String _usernameKey = 'username';

  // USERNAME - was missing
  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // ENTERPRISES
  Future<List<Enterprise>> getEnterprises() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_enterprisesKey);
    if (data == null) return [];
    final List decoded = jsonDecode(data);
    return decoded.map((e) => Enterprise.fromJson(e)).toList();
  }

  Future<void> saveEnterprises(List<Enterprise> enterprises) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(enterprises.map((e) => e.toJson()).toList());
    await prefs.setString(_enterprisesKey, data);
  }

  // ALIAS for single save - was missing
  Future<void> saveEnterprise(Enterprise enterprise) async {
    await addEnterprise(enterprise);
  }

  Future<void> addEnterprise(Enterprise enterprise) async {
    final enterprises = await getEnterprises();
    enterprises.add(enterprise);
    await saveEnterprises(enterprises);
  }

  // DELETE - was missing
  Future<void> deleteEnterprise(String id) async {
    final enterprises = await getEnterprises();
    enterprises.removeWhere((e) => e.id == id);
    await saveEnterprises(enterprises);
  }

  // FLOCKS
  Future<List<Flock>> getFlocks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_flocksKey);
    if (data == null) return [];
    final List decoded = jsonDecode(data);
    return decoded.map((e) => Flock.fromJson(e)).toList();
  }

  Future<void> saveFlocks(List<Flock> flocks) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(flocks.map((e) => e.toJson()).toList());
    await prefs.setString(_flocksKey, data);
  }
}
