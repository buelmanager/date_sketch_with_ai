// lib/view_models/auth_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_request.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

// 로그인 폼 상태
class LoginFormState {
  final String email;
  final String password;
  final bool showPassword;
  final String? emailError;
  final String? passwordError;

  LoginFormState({
    this.email = '',
    this.password = '',
    this.showPassword = false,
    this.emailError,
    this.passwordError,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? showPassword,
    String? emailError,
    bool clearEmailError = false,
    String? passwordError,
    bool clearPasswordError = false,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
    );
  }

  bool get isValid => emailError == null && passwordError == null && email.isNotEmpty && password.isNotEmpty;
}

// 회원가입 폼 상태
class RegisterFormState {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  final String? phoneNumber;
  final bool showPassword;
  final bool showConfirmPassword;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? nameError;

  RegisterFormState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.name = '',
    this.phoneNumber,
    this.showPassword = false,
    this.showConfirmPassword = false,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.nameError,
  });

  RegisterFormState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? name,
    String? phoneNumber,
    bool? showPassword,
    bool? showConfirmPassword,
    String? emailError,
    bool clearEmailError = false,
    String? passwordError,
    bool clearPasswordError = false,
    String? confirmPasswordError,
    bool clearConfirmPasswordError = false,
    String? nameError,
    bool clearNameError = false,
  }) {
    return RegisterFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
      confirmPasswordError: clearConfirmPasswordError ? null : (confirmPasswordError ?? this.confirmPasswordError),
      nameError: clearNameError ? null : (nameError ?? this.nameError),
    );
  }

  bool get isValid =>
      emailError == null &&
          passwordError == null &&
          confirmPasswordError == null &&
          nameError == null &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          name.isNotEmpty &&
          password == confirmPassword;
}

// 인증 상태
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// 로그인 뷰모델
class LoginViewModel extends StateNotifier<LoginFormState> {
  final AuthRepository _repository;

  LoginViewModel(this._repository) : super(LoginFormState());

  void updateEmail(String email) {
    String? error;
    if (email.isNotEmpty && !_repository.isValidEmail(email)) {
      error = '유효한 이메일 주소를 입력해주세요.';
    }
    state = state.copyWith(
      email: email,
      emailError: error,
      clearEmailError: error == null,
    );
  }

  void updatePassword(String password) {
    String? error;
    if (password.isNotEmpty && !_repository.isValidPassword(password)) {
      error = '비밀번호는 6자 이상이어야 합니다.';
    }
    state = state.copyWith(
      password: password,
      passwordError: error,
      clearPasswordError: error == null,
    );
  }

  void toggleShowPassword() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  Future<LoginResult> login() async {
    // 입력값 검증
    if (state.email.isEmpty) {
      state = state.copyWith(emailError: '이메일을 입력해주세요.');
      return LoginResult.invalidInput;
    }

    if (state.password.isEmpty) {
      state = state.copyWith(passwordError: '비밀번호를 입력해주세요.');
      return LoginResult.invalidInput;
    }

    if (!_repository.isValidEmail(state.email)) {
      state = state.copyWith(emailError: '유효한 이메일 주소를 입력해주세요.');
      return LoginResult.invalidInput;
    }

    if (!_repository.isValidPassword(state.password)) {
      state = state.copyWith(passwordError: '비밀번호는 6자 이상이어야 합니다.');
      return LoginResult.invalidInput;
    }

    try {
      final request = LoginRequest(
        email: state.email,
        password: state.password,
      );

      // 로그인 요청
      await _repository.login(request);
      return LoginResult.success;

    } catch (e) {
      if (e.toString().contains('이메일 또는 비밀번호가 올바르지 않습니다')) {
        return LoginResult.invalidCredentials;
      }
      return LoginResult.error;
    }
  }
}

// 회원가입 뷰모델
class RegisterViewModel extends StateNotifier<RegisterFormState> {
  final AuthRepository _repository;

  RegisterViewModel(this._repository) : super(RegisterFormState());

  void updateEmail(String email) {
    String? error;
    if (email.isNotEmpty && !_repository.isValidEmail(email)) {
      error = '유효한 이메일 주소를 입력해주세요.';
    }
    state = state.copyWith(
      email: email,
      emailError: error,
      clearEmailError: error == null,
    );
  }

  void updatePassword(String password) {
    String? error;
    if (password.isNotEmpty && !_repository.isValidPassword(password)) {
      error = '비밀번호는 6자 이상이어야 합니다.';
    }

    String? confirmError;
    if (state.confirmPassword.isNotEmpty && password != state.confirmPassword) {
      confirmError = '비밀번호가 일치하지 않습니다.';
    }

    state = state.copyWith(
      password: password,
      passwordError: error,
      clearPasswordError: error == null,
      confirmPasswordError: confirmError,
      clearConfirmPasswordError: confirmError == null,
    );
  }

  void updateConfirmPassword(String confirmPassword) {
    String? error;
    if (confirmPassword.isNotEmpty && confirmPassword != state.password) {
      error = '비밀번호가 일치하지 않습니다.';
    }
    state = state.copyWith(
      confirmPassword: confirmPassword,
      confirmPasswordError: error,
      clearConfirmPasswordError: error == null,
    );
  }

  void updateName(String name) {
    String? error;
    if (name.isNotEmpty && name.length < 2) {
      error = '이름은 2자 이상이어야 합니다.';
    }
    state = state.copyWith(
      name: name,
      nameError: error,
      clearNameError: error == null,
    );
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void toggleShowPassword() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  void toggleShowConfirmPassword() {
    state = state.copyWith(showConfirmPassword: !state.showConfirmPassword);
  }

  Future<RegisterResult> register() async {
    // 입력값 검증
    if (state.email.isEmpty) {
      state = state.copyWith(emailError: '이메일을 입력해주세요.');
      return RegisterResult.invalidInput;
    }

    if (state.password.isEmpty) {
      state = state.copyWith(passwordError: '비밀번호를 입력해주세요.');
      return RegisterResult.invalidInput;
    }

    if (state.confirmPassword.isEmpty) {
      state = state.copyWith(confirmPasswordError: '비밀번호 확인을 입력해주세요.');
      return RegisterResult.invalidInput;
    }

    if (state.name.isEmpty) {
      state = state.copyWith(nameError: '이름을 입력해주세요.');
      return RegisterResult.invalidInput;
    }

    if (!_repository.isValidEmail(state.email)) {
      state = state.copyWith(emailError: '유효한 이메일 주소를 입력해주세요.');
      return RegisterResult.invalidInput;
    }

    if (!_repository.isValidPassword(state.password)) {
      state = state.copyWith(passwordError: '비밀번호는 6자 이상이어야 합니다.');
      return RegisterResult.invalidInput;
    }

    if (state.password != state.confirmPassword) {
      state = state.copyWith(confirmPasswordError: '비밀번호가 일치하지 않습니다.');
      return RegisterResult.invalidInput;
    }

    try {
      final request = RegisterRequest(
        email: state.email,
        password: state.password,
        name: state.name,
        phoneNumber: state.phoneNumber,
      );

      // 회원가입 요청
      await _repository.register(request);
      return RegisterResult.success;
    } catch (e) {
      if (e.toString().contains('이미 사용 중인 이메일입니다')) {
        state = state.copyWith(emailError: '이미 사용 중인 이메일입니다.');
        return RegisterResult.emailAlreadyExists;
      }
      return RegisterResult.error;
    }
  }
}

// 인증 뷰모델
class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthViewModel(this._repository) : super(AuthState()) {
    // 초기화 시 현재 사용자 확인
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.getCurrentUser();
      state = state.copyWith(
        user: user,
        isAuthenticated: user != null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '사용자 정보를 불러오는 중 오류가 발생했습니다.',
      );
    }
  }

  Future<void> login(LoginRequest request) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.login(request);
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.register(request);
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.logout();
      state = state.copyWith(
        user: null,
        isAuthenticated: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그아웃 중 오류가 발생했습니다.',
      );
    }
  }

  // 추가: Google 로그인 메소드
  Future<void> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.loginWithGoogle();
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }
}

// 결과 열거형
enum LoginResult {
  success,
  invalidInput,
  invalidCredentials,
  error,
}

enum RegisterResult {
  success,
  invalidInput,
  emailAlreadyExists,
  error,
}