import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String fullName;
  final String email;
  final String password;
  final String nim;

  final String semester;
  final String ipk;
  final String sks;
  final String prodi;
  final String fakultas;

  User({
    required this.fullName,
    required this.email,
    required this.password,
    this.nim = '1301213031',
    this.semester = '7',
    this.ipk = '3.89',
    this.sks = '144',
    this.prodi = 'D4 Sistem Multimedia',
    this.fakultas = 'Ilmu Terapan',
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'password': password,
    'nim': nim,
    'semester': semester,
    'ipk': ipk,
    'sks': sks,
    'prodi': prodi,
    'fakultas': fakultas,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    fullName: json['fullName'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    nim: json['nim'] ?? '1301213031',
    semester: json['semester'] ?? '7',
    ipk: json['ipk'] ?? '3.89',
    sks: json['sks'] ?? '144',
    prodi: json['prodi'] ?? 'D4 Sistem Multimedia',
    fakultas: json['fakultas'] ?? 'Ilmu Terapan',
  );
}

class AuthService {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';

  // In-memory backup storage (for web compatibility)
  static List<Map<String, dynamic>> _inMemoryUsers = [];
  static User? _currentUser;

  // Register a new user
  static Future<bool> register(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      debugPrint('=== REGISTER ATTEMPT ===');
      debugPrint('Full Name: $fullName');
      debugPrint('Email: $email');

      // Check if email already exists in memory
      if (_inMemoryUsers.any((u) => u['email'] == email)) {
        debugPrint('Email already exists in memory!');
        return false;
      }

      // Add new user to in-memory storage
      final newUser = {
        'fullName': fullName,
        'email': email,
        'password': password,
      };
      _inMemoryUsers.add(newUser);

      debugPrint('User registered successfully in memory!');
      debugPrint('Total users in memory: ${_inMemoryUsers.length}');
      debugPrint('All users: $_inMemoryUsers');

      // Also try to save to SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_usersKey, jsonEncode(_inMemoryUsers));
        debugPrint('Also saved to SharedPreferences');
      } catch (e) {
        debugPrint('SharedPreferences save failed (not critical): $e');
      }

      return true;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }

  // Login user
  static Future<User?> login(String email, String password) async {
    try {
      debugPrint('=== LOGIN ATTEMPT ===');
      debugPrint('Email: $email');
      debugPrint('Password length: ${password.length}');
      debugPrint('Users in memory: ${_inMemoryUsers.length}');
      debugPrint('All users: $_inMemoryUsers');

      // Search in memory first
      for (var u in _inMemoryUsers) {
        debugPrint('Checking user: ${u['email']}');
        if (u['email'] == email && u['password'] == password) {
          final user = User.fromJson(Map<String, dynamic>.from(u));
          _currentUser = user;
          debugPrint('Login successful! User: ${user.fullName}');
          return user;
        }
      }

      // If not found in memory, try SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        final usersJson = prefs.getString(_usersKey);
        if (usersJson != null) {
          final List<dynamic> users = jsonDecode(usersJson);
          for (var u in users) {
            if (u['email'] == email && u['password'] == password) {
              final user = User.fromJson(Map<String, dynamic>.from(u));
              _currentUser = user;
              // Also add to in-memory for future use
              _inMemoryUsers = users
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList();
              debugPrint('Login successful from SharedPreferences!');
              return user;
            }
          }
        }
      } catch (e) {
        debugPrint('SharedPreferences read failed: $e');
      }

      debugPrint('Login failed: No matching user found');
      return null;
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }

  // Update User
  static Future<bool> updateUser(User updatedUser) async {
    try {
      _currentUser = updatedUser;

      // Update in-memory
      int index = _inMemoryUsers.indexWhere(
        (u) => u['email'] == updatedUser.email,
      );
      if (index != -1) {
        _inMemoryUsers[index] = updatedUser.toJson();
      } else {
        // Fallback if not found (unexpected)
        _inMemoryUsers.add(updatedUser.toJson());
      }

      // Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usersKey, jsonEncode(_inMemoryUsers));

      // Also update current user session if we were storing it
      // but simplistic approach for now is fine since we rely on _currentUser

      return true;
    } catch (e) {
      debugPrint('Update user error: $e');
      return false;
    }
  }

  // Get current logged in user
  static Future<User?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_currentUserKey);
      if (userJson != null) {
        _currentUser = User.fromJson(jsonDecode(userJson));
        return _currentUser;
      }
      return null;
    } catch (e) {
      debugPrint('Get current user error: $e');
      return null;
    }
  }

  // Logout user
  static Future<void> logout() async {
    _currentUser = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  // Debug: Get all registered users count
  static int get registeredUsersCount => _inMemoryUsers.length;
}
