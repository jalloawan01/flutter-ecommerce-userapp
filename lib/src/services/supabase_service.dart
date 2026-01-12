import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Singleton pattern
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient client = Supabase.instance.client;

  Future<AuthResponse> login(String email, String password) async {
    try {
      return await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      // Rethrow so the caller can surface a user-friendly message.
      throw AuthException(e.message);
    }
  }

  Future<AuthResponse> signUp(
    String email,
    String password, {
    String? name,
    String? role,
  }) async {
    try {
      final metadata = <String, dynamic>{};
      if (name != null && name.isNotEmpty) metadata['name'] = name;
      if (role != null && role.isNotEmpty) metadata['role'] = role;

      return await client.auth.signUp(
        email: email,
        password: password,
        data: metadata.isEmpty ? null : metadata,
      );
    } on AuthException catch (e) {
      throw AuthException(e.message);
    }
  }

  Future<void> signInWithProvider(OAuthProvider provider) async {
    try {
      await client.auth.signInWithOAuth(provider);
    } on AuthException catch (e) {
      throw AuthException(e.message);
    }
  }

  User? get currentUser => client.auth.currentUser;

  /// Convenience to read role from user metadata (e.g., 'user' or 'admin').
  String? get currentRole => currentUser?.userMetadata?['role'] as String?;

  Future<void> signOut() async {
    await client.auth.signOut();
  }
}
