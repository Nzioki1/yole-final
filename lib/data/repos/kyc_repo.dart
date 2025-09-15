import '../api/yole_api_client.dart';

/// KYC (Know Your Customer) repository
///
/// Handles:
/// - SMS OTP verification
/// - KYC validation with ID documents
/// - Email verification resend
///
/// Uses dynamic models for MVP - TODO: Add strong typing later
class KycRepository {
  const KycRepository(this._apiClient);

  final YoleApiClient _apiClient;

  /// Send SMS OTP to phone number
  ///
  /// Expected payload: { phone_number }
  Future<Map<String, dynamic>> sendSmsOtp({required String phoneNumber}) async {
    return await _apiClient.sendSmsOtp({'phone_number': phoneNumber});
  }

  /// Validate KYC with phone, OTP, ID number and images
  ///
  /// Expected payload: {
  ///   phone_number,
  ///   otp_code,
  ///   id_number,
  ///   id_front_image,
  ///   id_back_image (optional),
  ///   passport_image (optional)
  /// }
  Future<Map<String, dynamic>> validateKyc({
    required String phoneNumber,
    required String otpCode,
    required String idNumber,
    required String idFrontImage,
    String? idBackImage,
    String? passportImage,
  }) async {
    final payload = {
      'phone_number': phoneNumber,
      'otp_code': otpCode,
      'id_number': idNumber,
      'id_front_image': idFrontImage,
    };

    if (idBackImage != null) {
      payload['id_back_image'] = idBackImage;
    }

    if (passportImage != null) {
      payload['passport_image'] = passportImage;
    }

    return await _apiClient.validateKyc(payload);
  }

  /// Resend email verification
  Future<void> resendEmailVerification() async {
    await _apiClient.resendEmailVerification();
  }

  /// Send OTP for phone verification
  Future<Map<String, dynamic>> sendOtp({required String phoneNumber}) async {
    return await _apiClient.sendSmsOtp({'phone': phoneNumber});
  }

  /// Validate OTP for phone verification
  Future<Map<String, dynamic>> validateOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    return await _apiClient.sendSmsOtp({'phone': phoneNumber, 'otp': otp});
  }
}
