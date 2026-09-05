import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);
  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class ApiService {
  ApiService._internal();
  static final ApiService instance = ApiService._internal();

  String? _token;

  void setToken(String? token) => _token = token;

  Map<String, String> _headers() {
    final h = {'Content-Type': 'application/json', 'Accept': 'application/json'};
    if (_token != null && _token!.isNotEmpty) h['Authorization'] = 'Bearer $_token';
    return h;
  }

  Uri _uri(String path, [Map<String, String>? q]) {
    final base = kApiUrl.endsWith('/') ? kApiUrl.substring(0, kApiUrl.length - 1) : kApiUrl;
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$p').replace(queryParameters: q);
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final res = await http.get(_uri(path, query), headers: _headers());
    return _process(res);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final res = await http.post(_uri(path), headers: _headers(), body: jsonEncode(body ?? {}));
    return _process(res);
  }

  Future<dynamic> delete(String path) async {
    final res = await http.delete(_uri(path), headers: _headers());
    return _process(res);
  }

  dynamic _process(http.Response res) {
    final s = res.statusCode;
    if (s >= 200 && s < 300) {
      if (res.body.isEmpty) return null;
      try {
        return jsonDecode(res.body);
      } catch (_) {
        return res.body;
      }
    }
    String message = 'Erro ${res.statusCode}';
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map && decoded['message'] != null) message = decoded['message'];
    } catch (_) {}
    throw ApiException(message, s);
  }
}