import 'dart:async';
import 'dart:convert';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:http/http.dart' as http;

import '../cache/cache_key.dart';
import '../cache/cache_store.dart';
import 'api_response.dart';

abstract class ApiClient {
  Future<ApiResponse> post({
    required String url,
    required Map<String, dynamic> body,
  });
  Future<ApiResponse> get({required String url});
  Future<ApiResponse> patch({
    required String url,
    required Map<String, dynamic> body,
  });
  Future<ApiResponse> put({
    required String url,
    required Map<String, dynamic> body,
  });
  Future<ApiResponse> delete({required String url});
}

class ApiClientImpl implements ApiClient {
  final CacheStore _cacheStore;

  ApiClientImpl({
    required CacheStore cacheStore,
  }) : _cacheStore = cacheStore;

  @override
  Future<ApiResponse> delete({required String url}) async {
    url.log();
    try {
      final token = await _cacheStore.load(key: CacheKey.token);
      final response = await http.delete(
        Uri.parse(url),
        headers: _getHeadersOption(token),
      );

      final output = json.decode(response.body);
      "out-put $output".log();
      if (response.statusCode >= 200 || response.statusCode <= 302) {
        return ApiResponse.fromJson(output);
      }
      throw ApiResponse.fromJson(output);
    } on TimeoutException catch (_) {
      throw "Request Timeout, Try Again.";
    } on http.ClientException catch (_) {
      throw "Something went wrong, Try Again.";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse> get({required String url}) async {
    try {
      print(url);
      final token = await _cacheStore.load(key: CacheKey.token);
      final response = await http.get(
        Uri.parse(url),
        headers: _getHeadersOption(token),
      );

      final output = json.decode(response.body);
      print("output:$output");
      "out-put $output".log();
      if (response.statusCode >= 200 || response.statusCode <= 302) {
        return ApiResponse.fromJson(output);
      }
      throw ApiResponse.fromJson(output);
    } on TimeoutException catch (_) {
      throw "Request Timeout, Try Again.";
    } on http.ClientException catch (_) {
      throw "Something went wrong, Try Again.";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse> patch({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      final token = await _cacheStore.load(key: CacheKey.token);
      final response = await http.patch(
        Uri.parse(url),
        headers: _getHeadersOption(token),
        body: json.encode(body),
      );
      final output = json.decode(response.body);
      "out-put $output".log();
      if (response.statusCode >= 200 || response.statusCode <= 302) {
        return ApiResponse.fromJson(output);
      }
      throw ApiResponse.fromJson(output);
    } on TimeoutException catch (_) {
      throw "Request Timeout, Try Again.";
    } on http.ClientException catch (_) {
      throw "Something went wrong, Try Again.";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse> put({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      final token = await _cacheStore.load(key: CacheKey.token);
      final response = await http.put(
        Uri.parse(url),
        headers: _getHeadersOption(token),
        body: json.encode(body),
      );

      final output = json.decode(response.body);
      if (response.statusCode >= 200 || response.statusCode <= 302) {
        return ApiResponse.fromJson(output);
      }
      throw ApiResponse.fromJson(output);
    } on TimeoutException catch (_) {
      throw "Request Timeout, Try Again.";
    } on http.ClientException catch (_) {
      throw "Something went wrong, Try Again.";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse> post({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      print(body);
      print(url);
      final token = await _cacheStore.load(key: CacheKey.token);
      final response = await http.post(
        Uri.parse(url),
        headers: _getHeadersOption(token),
        body: json.encode(body),
      );

      final output = json.decode(response.body);
      "out-put $output".log();
      if (response.statusCode >= 200 || response.statusCode <= 302) {
        return ApiResponse.fromJson(output);
      }
      throw ApiResponse.fromJson(output);
    } on TimeoutException catch (_) {
      throw "Request Timeout, Try Again.";
    } on http.ClientException catch (_) {
      throw "Something went wrong, Try Again.";
    } catch (e) {
      rethrow;
    }
  }

  Map<String, String> _getHeadersOption(String token) {
    token.log();
    return {
      "content-type": "application/json",
      "Authorization": "Bearer $token",
      "Accept": "application/json"
    };
  }
}
