import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_pro/services/api_service.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });

  test('Test Auth Register, Login, and Profile Flow', () async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final testEmail = 'user_$timestamp@test.com';
    final testPassword = 'Password123!';
    final testName = 'Test User $timestamp';

    // 1. Register
    final registeredUser = await ApiService.authRegister(testName, testEmail, testPassword);
    expect(registeredUser.email, testEmail);
    expect(registeredUser.name, testName);
    expect(registeredUser.role, 'USER');

    // 2. Login
    final authResp = await ApiService.authLogin(testEmail, testPassword);
    expect(authResp.accessToken.isNotEmpty, true);
    expect(authResp.refreshToken.isNotEmpty, true);
    expect(authResp.user.email, testEmail);

    // 3. Me / Profile
    final profile = await ApiService.getProfile(authResp.accessToken);
    expect(profile.id, authResp.user.id);
    expect(profile.email, testEmail);
  });
}
