import 'dart:convert' show jsonEncode;

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' show MockClient;
import 'package:flutter_interview_app/core/network/http_client.dart';
import 'package:flutter_interview_app/core/exceptions/exception_handler.dart';

void main() {
  group('AppHttpClientImpl', () {
    test('returns decoded JSON on 200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'id': 1, 'title': 'Test'}), 200);
      });

      final client = AppHttpClientImpl(client: mockClient);
      final result = await client.get('https://example.com/api');

      expect(result, isA<Map>());
      expect(result['id'], 1);
      expect(result['title'], 'Test');
    });

    test('returns decoded JSON list on 200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
            jsonEncode([
              {'id': 1},
              {'id': 2}
            ]),
            200);
      });

      final client = AppHttpClientImpl(client: mockClient);
      final result = await client.get('https://example.com/api');

      expect(result, isA<List>());
      expect(result.length, 2);
    });

    test('throws ServerException on non-200 status codes', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final client = AppHttpClientImpl(client: mockClient);

      expect(
        () => client.get('https://example.com/api'),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws ServerException with statusCode on 404', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final client = AppHttpClientImpl(client: mockClient);

      try {
        await client.get('https://example.com/api');
        fail('Expected ServerException');
      } on ServerException catch (e) {
        expect(e.statusCode, 404);
      }
    });

    test('converts network errors to NetworkException via ExceptionHandler',
        () async {
      final mockClient = MockClient((request) async {
        throw http.ClientException('Connection refused');
      });

      final client = AppHttpClientImpl(client: mockClient);

      expect(
        () => client.get('https://example.com/api'),
        throwsA(isA<NetworkException>()),
      );
    });

    test('sends correct headers', () async {
      late Map<String, String> capturedHeaders;
      final mockClient = MockClient((request) async {
        capturedHeaders = request.headers;
        return http.Response('{}', 200);
      });

      final client = AppHttpClientImpl(client: mockClient);
      await client.get('https://example.com/api');

      expect(capturedHeaders['User-Agent'], 'TodosExplorer/1.0');
      expect(capturedHeaders['Accept'], 'application/json');
    });

    test('dispose does not throw', () {
      final mockClient = MockClient((request) async {
        return http.Response('{}', 200);
      });
      final client = AppHttpClientImpl(client: mockClient);
      expect(() => client.dispose(), returnsNormally);
    });
  });
}
