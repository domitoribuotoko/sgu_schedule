import 'package:dio/dio.dart';
import 'package:sgu_schedule/core/config/schedule_api_config.dart';
import 'package:sgu_schedule/data/network/schedule_api_asset_mock_interceptor.dart';

Dio createScheduleDio() {
  final d = Dio(
    BaseOptions(
      // CORS/HTTPS: см. [ScheduleApiConfig]
      baseUrl: ScheduleApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: const {'Accept': 'application/json'},
    ),
  );
  if (ScheduleApiConfig.useAssetMocks) {
    d.interceptors.add(ScheduleApiAssetMockInterceptor());
  }
  return d;
}
