import 'dart:convert' show jsonDecode;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:http/http.dart' as http;

import '../exceptions/exception_handler.dart'
    show AppException, ServerException, ExceptionHandler;

abstract interface class AppHttpClient {
  Future<dynamic> get(String url);
  void dispose();
}

class AppHttpClientImpl implements AppHttpClient {
  final http.Client _client;

  AppHttpClientImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<dynamic> get(String url) async {
    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'TodosExplorer/1.0',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ServerException(
          message:
              'Server responded with status ${kDebugMode ? response.statusCode : 'Unknown'}',
          statusCode: response.statusCode,
        );
      }
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw ExceptionHandler.handleHttpException(e, st);
    }
  }

  @override
  void dispose() => _client.close();
}
