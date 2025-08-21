import 'dart:convert';
import 'dart:io';
import 'app_config.dart';
import 'exception_handler.dart';

class ApiClient {
  final AppConfig config = const AppConfig();

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse("${config.baseUrl}$endpoint");
      final request = await client.postUrl(uri);
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.add(utf8.encode(jsonEncode(body)));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        throw ApiException("Error ${response.statusCode}: $responseBody");
      }
    } catch (e) {
      throw ApiException("Network error: $e");
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse("${config.baseUrl}$endpoint");
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        throw ApiException("Error ${response.statusCode}: $responseBody");
      }
    } catch (e) {
      throw ApiException("Network error: $e");
    } finally {
      client.close();
    }
  }
}
