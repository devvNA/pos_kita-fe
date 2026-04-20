// lib/core/network/example_usage.dart
// ─── CONTOH PENGGUNAAN ────────────────────────────────────────────────────

import 'dart:developer';

import 'network.dart';

// ──────────────────────────────────────────────────────────────────────────
// 1. MODEL
// ──────────────────────────────────────────────────────────────────────────

class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
  );

  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

// ──────────────────────────────────────────────────────────────────────────
// 2. REPOSITORY LAYER — menggunakan HttpClient
// ──────────────────────────────────────────────────────────────────────────

class UserRepository {
  late final HttpClient _client;

  UserRepository() {
    _client = HttpClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      timeout: const Duration(seconds: 15),
      maxRetries: 2,
      // Inject token secara dinamis
      tokenProvider: () async => 'your-jwt-token-here',
      logger: const HttpLogger(
        enabled: true, // set ke `kDebugMode` di production
        level: LogLevel.debug,
      ),
    );
  }

  /// GET semua users
  Future<ApiResponse<List<User>>> getUsers() {
    return _client.get<List<User>>(
      '/users',
      fromJson: (json) => (json as List)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// GET user by ID
  Future<ApiResponse<User>> getUserById(int id) {
    return _client.get<User>(
      '/users/$id',
      fromJson: (json) => User.fromJson(json as Map<String, dynamic>),
    );
  }

  /// GET dengan query params
  Future<ApiResponse<List<User>>> searchUsers(String query) {
    return _client.get<List<User>>(
      '/users',
      queryParams: {'search': query, 'limit': '10'},
      fromJson: (json) => (json as List)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// POST — Buat user baru
  Future<ApiResponse<User>> createUser(User user) {
    return _client.post<User>(
      '/users',
      body: user.toJson(),
      fromJson: (json) => User.fromJson(json as Map<String, dynamic>),
    );
  }

  /// PUT — Update seluruh data user
  Future<ApiResponse<User>> updateUser(int id, User user) {
    return _client.put<User>(
      '/users/$id',
      body: user.toJson(),
      fromJson: (json) => User.fromJson(json as Map<String, dynamic>),
    );
  }

  /// PATCH — Update sebagian data user
  Future<ApiResponse<User>> patchUser(int id, Map<String, dynamic> data) {
    return _client.patch<User>(
      '/users/$id',
      body: data,
      fromJson: (json) => User.fromJson(json as Map<String, dynamic>),
    );
  }

  /// DELETE user
  Future<ApiResponse<void>> deleteUser(int id) {
    return _client.delete('/users/$id');
  }

  void dispose() => _client.dispose();
}

// ──────────────────────────────────────────────────────────────────────────
// 3. CONTOH PEMANGGILAN DI VIEWMODEL / USE CASE
// ──────────────────────────────────────────────────────────────────────────

Future<void> exampleUsage() async {
  final repo = UserRepository();

  try {
    // GET semua users
    final response = await repo.getUsers();
    if (response.success && response.data != null) {
      log('Jumlah users: ${response.data!.length}');
    }

    // POST user baru
    final newUser = const User(
      id: 0,
      name: 'Budi Santoso',
      email: 'budi@example.com',
    );
    final created = await repo.createUser(newUser);
    log('Created: ${created.data}');
  } on UnauthorizedException catch (e) {
    // Redirect ke halaman login
    log('Session expired: ${e.message}');
  } on NetworkException catch (e) {
    // Tampilkan snackbar "No internet"
    log('Network error: ${e.message}');
  } on ApiException catch (e) {
    // Error handling umum
    log('API error [${e.statusCode}]: ${e.message}');
  } finally {
    repo.dispose();
  }
}
