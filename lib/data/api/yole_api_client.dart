import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../core/network/dio_client.dart';

part 'yole_api_client.g.dart';

/// Yole API client using Retrofit
///
/// Implements all endpoints from PRD Section 9:
/// - System endpoints (status, countries)
/// - Auth & Session endpoints
/// - Verification endpoints (SMS, KYC, email)
/// - Fees & Quotes endpoints
/// - Send & Transactions endpoints
///
/// Uses dynamic models for MVP - TODO: Add strong typing later
@RestApi()
abstract class YoleApiClient {
  factory YoleApiClient(Dio dio, {String? baseUrl}) = _YoleApiClient;

  // System endpoints
  @GET('/api/status')
  Future<dynamic> getStatus();

  @GET('/api/countries')
  Future<dynamic> getCountries();

  // Auth & Session endpoints
  @POST('/api/register')
  Future<dynamic> register(@Body() Map<String, dynamic> userData);

  @POST('/api/login')
  Future<dynamic> login(@Body() Map<String, dynamic> credentials);

  @POST('/api/refresh-token')
  Future<dynamic> refreshToken(@Body() Map<String, dynamic> refreshData);

  // POST with no body -> void
  @POST('/api/logout')
  Future<void> logout();

  // POST single value -> use FormUrlEncoded + Field
  @FormUrlEncoded()
  @POST('/api/password/forgot')
  Future<dynamic> forgotPassword(@Field('email') String email);

  // Verification endpoints
  @POST('/api/sms/send-otp')
  Future<dynamic> sendSmsOtp(@Body() Map<String, dynamic> phoneData);

  @POST('/api/validate-kyc')
  Future<dynamic> validateKyc(@Body() Map<String, dynamic> kycData);

  // POST with no body -> void
  @POST('/api/email/verification-notification')
  Future<void> resendEmailVerification();

  // Fees & Quotes endpoints
  @POST('/api/charges')
  Future<dynamic> getCharges(@Body() Map<String, dynamic> chargeRequest);

  @POST('/api/yole-charges')
  Future<dynamic> getYoleCharges(@Body() Map<String, dynamic> chargeRequest);

  // Send & Transactions endpoints
  @POST('/api/send-money')
  Future<dynamic> sendMoney(@Body() Map<String, dynamic> sendRequest);

  @POST('/api/transaction/status')
  Future<dynamic> getTransactionStatus(
    @Body() Map<String, dynamic> statusRequest,
  );

  @GET('/api/transactions')
  Future<dynamic> getTransactions();
}

/// Factory function to create YoleApiClient instance
YoleApiClient createYoleApiClient() {
  return YoleApiClient(YoleDioClient.yoleDio);
}
