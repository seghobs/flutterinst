import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cookie.dart';

class CookieProvider extends ChangeNotifier {
  List<Cookie> _cookies = [];
  
  List<Cookie> get cookies => _cookies;
  
  CookieProvider() {
    loadCookies();
  }
  
  Future<void> loadCookies() async {
    final prefs = await SharedPreferences.getInstance();
    final cookiesJson = prefs.getString('instagram_cookies');
    
    if (cookiesJson != null) {
      final List<dynamic> cookiesList = json.decode(cookiesJson);
      _cookies = cookiesList.map((c) => Cookie.fromJson(c)).toList();
      notifyListeners();
    }
  }
  
  Future<bool> saveCookies(String cookiesJson) async {
    try {
      // JSON parse et
      final List<dynamic> cookiesList = json.decode(cookiesJson);
      
      // Cookie modellerine dönüştür
      _cookies = cookiesList.map((c) => Cookie.fromJson(c)).toList();
      
      // SharedPreferences'a kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('instagram_cookies', cookiesJson);
      
      notifyListeners();
      return true;
    } catch (e) {
      print('Cookie kaydetme hatası: $e');
      return false;
    }
  }
  
  Future<void> clearCookies() async {
    _cookies = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('instagram_cookies');
    notifyListeners();
  }
  
  String getCookieHeader() {
    // HTTP header için cookie string'i oluştur
    return _cookies
        .map((c) => '${c.name}=${c.value}')
        .join('; ');
  }
  
  Cookie? getCookie(String name) {
    try {
      return _cookies.firstWhere((c) => c.name == name);
    } catch (e) {
      return null;
    }
  }
  
  String? getSessionId() {
    final sessionCookie = getCookie('sessionid');
    return sessionCookie?.value;
  }
  
  String? getCsrfToken() {
    final csrfCookie = getCookie('csrftoken');
    return csrfCookie?.value;
  }
  
  String? getUserId() {
    final userIdCookie = getCookie('ds_user_id');
    return userIdCookie?.value;
  }
}
