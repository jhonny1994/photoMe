import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.authenticated() = _Authenticated;

  const factory AuthState.failure(String message) = _Failure;

  const factory AuthState.loading() = _Loading;

  const factory AuthState.onboarding() = _Onboarding;

  const factory AuthState.unauthenticated() = _Unauthenticated;

  const factory AuthState.verification(
    String email,
    String password,
    String username,
  ) = _Verification;
}
