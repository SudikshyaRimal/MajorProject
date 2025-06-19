import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'hive_keys.dart';

class HiveDataSource {
  // Singleton pattern
  static final HiveDataSource _instance = HiveDataSource._internal();
  HiveDataSource._internal(); // Private constructor

  factory HiveDataSource() => _instance;

  // Box? _authBox; // Add this cache
  LazyBox? _authBox; // Add this cache


  Future<LazyBox> openBox(String boxName) async {
    if (_authBox != null && _authBox!.isOpen) {
      return _authBox!;
    }

    try {
      _authBox = await Hive.openLazyBox(boxName);
      log('📦 LazyBox opened successfully: $boxName');
      return _authBox!;
    } catch (e) {
      log('❌ Error opening LazyBox: $e');
      rethrow;
    }
  }


  Future<void> clearAccessToken() async {
    try {
      final hiveAuthBox = await openBox(HIVE_TOKEN_BOX);
      await hiveAuthBox.delete(HIVE_TOKEN_KEY);
    } catch (e) {}
  }


  Future<String> updateAccessToken(String token) async {
    try {
      final hiveAuthBox = await openBox(HIVE_TOKEN_BOX);
      await hiveAuthBox.put(HIVE_TOKEN_KEY, token);
      return await getAccessToken();
    } catch (e) {
      return '';
    }
  }

  Future<String> getAccessToken() async {
    try {
      final hiveAuthBox = await openBox(HIVE_TOKEN_BOX);
      final result = await hiveAuthBox.get(HIVE_TOKEN_KEY);

      log("Access token Get :  ${result ?? ''}");
      return result ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<void> clearRefreshToken() async {
    try {
      final hiveAuthBox = await openBox(HIVE_TOKEN_BOX);
      await hiveAuthBox.delete(HIVE_REFRESH_TOKEN_KEY);
    } catch (e) {}
  }

  Future<String> getRefreshToken() async {
    try {
      final hiveAuthBox = await openBox(HIVE_TOKEN_BOX);
      final result = await hiveAuthBox.get(HIVE_REFRESH_TOKEN_KEY);

      return result ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<String> updateRefreshToken(String token) async {
    try {
      final hiveAuthBox = await openBox(HIVE_TOKEN_BOX);
      await hiveAuthBox.put(HIVE_REFRESH_TOKEN_KEY, token);
      return await getRefreshToken();
    } catch (e) {
      return '';
    }
  }


  // New method to clear all data in the Hive box
  Future<void> clearAll() async {
    try {
      clearRefreshToken();
      clearAccessToken();
      log('📦 All data cleared ');
    } catch (e) {
      log('❌ Error clearing Hive box: $e');
    }
  }


}