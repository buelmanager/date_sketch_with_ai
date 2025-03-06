// lib/providers/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../view_models/auth_view_model.dart';

// 인증 저장소 Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// 인증 ViewModel Provider
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthViewModel(repository);
});

// 로그인 ViewModel Provider
final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginFormState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginViewModel(repository);
});

// 회원가입 ViewModel Provider
final registerViewModelProvider = StateNotifierProvider<RegisterViewModel, RegisterFormState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterViewModel(repository);
});