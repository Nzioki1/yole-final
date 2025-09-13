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
  Future<Map<String, dynamic>> getStatus();

  @GET('/api/countries')
  Future<List<Map<String, dynamic>>> getCountries(); // <-- concrete element type

  // Auth & Session endpoints
  @POST('/api/register')
  Future<Map<String, dynamic>> register(@Body() Map<String, dynamic> userData);

  @POST('/api/login')
  Future<Map<String, dynamic>> login(@Body() Map<String, dynamic> credentials);

  @POST('/api/refresh-token')
  Future<Map<String, dynamic>> refreshToken(@Body() Map<String, dynamic> refreshData);

  // POST with no body -> void
  @POST('/api/logout')
  Future<void> logout();

  // POST single value -> use FormUrlEncoded + Field
  @FormUrlEncoded()
  @POST('/api/password/forgot')
  Future<Map<String, dynamic>> forgotPassword(@Field('email') String email);

  // Verification endpoints
  @POST('/api/sms/send-otp')
  Future<Map<String, dynamic>> sendSmsOtp(@Body() Map<String, dynamic> phoneData);

  @POST('/api/validate-kyc')
  Future<Map<String, dynamic>> validateKyc(@Body() Map<String, dynamic> kycData);

  // POST with no body -> void
  @POST('/api/email/verification-notification')
  Future<void> resendEmailVerification();

  // Fees & Quotes endpoints
  @POST('/api/charges')
  Future<Map<String, dynamic>> getCharges(@Body() Map<String, dynamic> chargeRequest);

  @POST('/api/yole-charges')
  Future<Map<String, dynamic>> getYoleCharges(@Body() Map<String, dynamic> chargeRequest);

  // Send & Transactions endpoints
  @POST('/api/send-money')
  Future<Map<String, dynamic>> sendMoney(@Body() Map<String, dynamic> sendRequest);

  @POST('/api/transaction/status')
  Future<Map<String, dynamic>> getTransactionStatus(@Body() Map<String, dynamic> statusRequest);

  @GET('/api/transactions')
  Future<List<Map<String, dynamic>>> getTransactions(); // <-- concrete element type
}

/// Factory function to create YoleApiClient instance
YoleApiClient createYoleApiClient() {
  return YoleApiClient(YoleDioClient.yoleDio);
}
