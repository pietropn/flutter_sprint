import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
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

  /// Executa uma requisição HTTP e converte qualquer falha de comunicação
  /// (servidor fora do ar, endereço incorreto, timeout, ou bloqueio de CORS
  /// quando rodando no navegador) em uma [ApiException] com mensagem clara
  /// para o usuário, em vez de deixar a exceção "crua" chegar até a tela.
  Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      final res = await request().timeout(const Duration(seconds: 8));
      return _process(res);
    } on http.ClientException catch (e) {
      // No Flutter Web, falhas de rede (servidor fora do ar, endereço
      // incorreto ou bloqueio de CORS do navegador) chegam aqui como
      // http.ClientException — não como SocketException (que é exclusiva
      // de dart:io e não é lançada em builds Web).
      if (kIsWeb) {
        throw ApiException(
          'Não foi possível conectar à API em $baseUrl.\n'
          'Verifique se ela está rodando nesse endereço. Se estiver e o '
          'erro persistir, provavelmente é bloqueio de CORS do navegador — '
          'peça para habilitar CORS no backend, ou teste o app em um '
          'emulador/dispositivo ou como app desktop, onde essa restrição '
          'não existe.\n(detalhe técnico: ${e.message})',
        );
      }
      throw ApiException('Não foi possível conectar à API em $baseUrl. Verifique a conexão.');
    } on SocketException {
      throw ApiException('Não foi possível conectar à API em $baseUrl. Verifique a conexão.');
    } on TimeoutException {
      throw ApiException('Tempo limite esgotado ao conectar à API.');
    }
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) {
    return _send(() => http.get(_uri(path, query), headers: _headers()));
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) {
    return _send(
      () => http.post(_uri(path), headers: _headers(), body: jsonEncode(body ?? {})),
    );
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) {
    return _send(
      () => http.put(_uri(path), headers: _headers(), body: jsonEncode(body ?? {})),
    );
  }

  Future<dynamic> delete(String path) {
    return _send(() => http.delete(_uri(path), headers: _headers()));
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
        // Formato de validação (422): { "errors": [ { "fieldName", "message" } ] }
        if (decoded['errors'] is List && (decoded['errors'] as List).isNotEmpty) {
          final mensagens = (decoded['errors'] as List)
              .whereType<Map>()
              .map((e) {
                final campo = e['fieldName']?.toString();
                final msg = e['message']?.toString() ?? '';
                return campo != null && campo.isNotEmpty ? '$campo: $msg' : msg;
              })
              .where((m) => m.isNotEmpty)
              .join('; ');
          if (mensagens.isNotEmpty) message = mensagens;
        } else if (decoded['error'] != null) {
          // Formato padrão de erro da API (CustomErrorDTO): { "error": "..." }
          message = decoded['error'].toString();
        } else if (decoded['message'] != null) {
          // Fallback para outras APIs que usem a chave "message"
          message = decoded['message'].toString();
        }
      }
    } catch (_) {}

    throw ApiException(message, s);
  }
}
