import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthResult {
  final bool success;
  final String message;

  const AuthResult({required this.success, required this.message});

  factory AuthResult.success(String message) => AuthResult(success: true, message: message);
  factory AuthResult.failure(String message) => AuthResult(success: false, message: message);
}

class AuthService {
  final SupabaseService _supabase = SupabaseService();
  static const Duration _requestTimeout = Duration(seconds: 15);

  // --- ADDED: SIGN IN WITH PROVIDER (Fixes the Login Page error) ---
  Future<AuthResult> signInWithProvider(OAuthProvider provider) async {
    try {
      await _supabase.client.auth.signInWithOAuth(
        provider,
        // Optional: redirectTo: 'io.supabase.flutter://login-callback/'
      ).timeout(_requestTimeout);
      
      return AuthResult.success('Redirecting to ${provider.name}...');
    } on AuthException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      return AuthResult.failure('Could not initiate social login.');
    }
  }

 Future<AuthResult> signUp(String name, String email, String password) async {
  try {
    // We only need to create the Auth User. 
    // The Database Trigger we created above handles the 'Profiles' table for us!
    final response = await _supabase.client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name}, // This 'name' is used by the Trigger
    ).timeout(_requestTimeout);

    if (response.user != null) {
      return AuthResult.success('Signup successful! Please check your email for a verification link.');
    }
    
    return AuthResult.failure('Signup failed. Please try again.');
  } on AuthException catch (e) {
    return AuthResult.failure(e.message);
  } catch (e) {
    debugPrint("Signup Error: $e");
    return AuthResult.failure('Connection error. Please try again.');
  }
}

  // --- LOGIN ---
  Future<AuthResult> login(String email, String password) async {
    try {
      final res = await _supabase.client.auth.signInWithPassword(
        email: email, 
        password: password,
      ).timeout(_requestTimeout);
      
      return res.user != null 
          ? AuthResult.success('Welcome back!') 
          : AuthResult.failure('Login failed.');
    } on AuthException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred.');
    }
  }

  // --- RESEND VERIFICATION ---
  Future<AuthResult> resendVerification(String email) async {
    try {
      await _supabase.client.auth.resend(
        type: OtpType.signup,
        email: email,
      ).timeout(_requestTimeout);
      return AuthResult.success('Verification email resent.');
    } catch (e) {
      return AuthResult.failure('Failed to resend email.');
    }
  }

  // --- LOGOUT ---
  Future<AuthResult> logout() async {
    try {
      await _supabase.client.auth.signOut();
      return AuthResult.success('Logged out.');
    } catch (e) {
      return AuthResult.failure('Logout failed.');
    }
  }
}