import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'preferences_service.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);
  @override
  String toString() => message;
}

class ApiService {
  ApiService._internal();
  static final ApiService instance = ApiService._internal();

  String? _token;

  void setToken(String? token) => _token = token;

  String get baseUrl => PreferencesService.instance.getApiUrl();

  Map<String, String> _headers() {
    final h = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      h['Authorization'] = 'Bearer $_token';
    }
    return h;
  }

  Uri _uri(String path, [Map<String, String>? q]) {
    final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$p').replace(queryParameters: q);
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    try {
      final res = await http
          .get(_uri(path, query), headers: _headers())
          .timeout(const Duration(seconds: 8));
      return _process(res);
    } on SocketException {
      throw ApiException('Não foi possível conectar à API em $baseUrl. Verifique a conexão.');
    } on TimeoutException {
      throw ApiException('Tempo limite esgotado ao conectar à API.');
    }
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    try {
      final res = await http
          .post(_uri(path), headers: _headers(), body: jsonEncode(body ?? {}))
          .timeout(const Duration(seconds: 8));
      return _process(res);
    } on SocketException {
      throw ApiException('Não foi possível conectar à API em $baseUrl. Verifique a conexão.');
    } on TimeoutException {
      throw ApiException('Tempo limite esgotado ao conectar à API.');
    }
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    try {
      final res = await http
          .put(_uri(path), headers: _headers(), body: jsonEncode(body ?? {}))
          .timeout(const Duration(seconds: 8));
      return _process(res);
    } on SocketException {
      throw ApiException('Não foi possível conectar à API em $baseUrl. Verifique a conexão.');
    } on TimeoutException {
      throw ApiException('Tempo limite esgotado ao conectar à API.');
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final res = await http
          .delete(_uri(path), headers: _headers())
          .timeout(const Duration(seconds: 8));
      return _process(res);
    } on SocketException {
      throw ApiException('Não foi possível conectar à API em $baseUrl. Verifique a conexão.');
    } on TimeoutException {
      throw ApiException('Tempo limite esgotado ao conectar à API.');
    }
  }

  dynamic _process(http.Response res) {
    final s = res.statusCode;
    if (s >= 200 && s < 300) {
      if (res.body.isEmpty) return null;
      try {
        return jsonDecode(utf8.decode(res.bodyBytes));
      } catch (_) {
        return res.body;
      }
    }

    String message = 'Erro $s';
    try {
      final decoded = jsonDecode(utf8.decode(res.bodyBytes));
      if (decoded is Map) {
        if (decoded['errors'] is List && (decoded['errors'] as List).isNotEmpty) {
          final first = (decoded['errors'] as List).first;
          if (first is Map && first['message'] != null) {
            message = first['message'].toString();
          }
        } else if (decoded['message'] != null) {
          message = decoded['message'].toString();
        }
      }
    } catch (_) {}

    throw ApiException(message, s);
  }
}
