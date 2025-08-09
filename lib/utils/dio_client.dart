import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://64a87884dca581464b85c6d2.mockapi.io/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.addAll([
    PrettyDioLogger(
      request: true,
      requestHeader: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
    ),
  ]);
  return dio;
}
