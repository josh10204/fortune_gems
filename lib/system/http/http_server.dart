import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fortune_gems/model/res/base_res.dart';
import 'package:fortune_gems/system/http/http_exceptions.dart';
import 'package:fortune_gems/system/http/http_setting.dart';
import 'package:fortune_gems/system/http/response_code.dart';


///MARK: 參考網站
///https://dhruvnakum.xyz/networking-in-flutter-dio#heading-repository
///
typedef ResponseErrorFunction = void Function(String errorMessage);
typedef onGetStringFunction = void Function(String value);

class HttpServer {
// dio instance
  final Dio _dio = Dio();
  final ResponseErrorFunction? onConnectFail;
  final onGetStringFunction? onConnectSuccess;
  // String baseUrl;
  final Map<String, dynamic>? headers;

  HttpServer({
    this.onConnectFail,
    this.onConnectSuccess,
    this.headers,
  }) {
    _dio
      // ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(milliseconds: HttpSetting.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: HttpSetting.receiveTimeout)
      ..options.responseType = ResponseType.json
      ..options.contentType = Headers.formUrlEncodedContentType
      ..options.headers.addAll(headers ?? {});
      // ..interceptors.add(DioInterceptor());
  }

  BaseRes _checkResponse(Response response) {
    debugPrint(response.realUri.toString());
    print('response runtimeType: ${response.data.runtimeType}');
    print('response : ${response.data}');

    if(response.data == '' || response.data == null) {
      return BaseRes(resultCode: 'emptyResultCode');
    }

    final BaseRes result = BaseRes.fromJson(response.data);
    /// API请求成功 检查response code， 如果有就return，否则进入Exception
    if (ResponseCode.map.containsKey(result.resultCode)) {
      if(result.resultCode == ResponseCode.CODE_SUCCESS) {
        callSuccessConnect(result.resultCode);
      } else {
        callFailConnect(result.resultCode);
      }
      return result;
    }

    ///取代錯誤code
    response.statusCode = 404;
    response.data['message'] = result.resultCode;
    throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse
    );
  }

  Future<void> addDioHeader(Map<String, String> header) async {
    header.forEach((key, value) {
      _dio.options.headers[key] = value;
      debugPrint("addDioHeader $key:${_dio.options.headers[key]}");
    });
  }

  void callFailConnect(String message) {
    if (onConnectFail != null) {
      onConnectFail!(message);
    }
  }

  void callSuccessConnect(String message) {
    if (onConnectSuccess != null) {
      onConnectSuccess!(message);
    }
  }

  double getDouble(json, String key) {
    return json[key] is int ? (json[key] as int).toDouble() : json[key];
  }

  // Get:-----------------------------------------------------------------------
  Future<BaseRes?> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return _checkResponse(response);
    } on DioException catch (e) {
      final errorMessage = HttpExceptions.fromDioError(e).toString();
      callFailConnect(errorMessage);
      throw errorMessage;
    } catch (e) {
      callFailConnect(e.toString());
      rethrow;
    }
  }



  // Post:----------------------------------------------------------------------
  Future<BaseRes?> post(
      String url, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _checkResponse(response);
    } on DioException catch (e) {
      final errorMessage = HttpExceptions.fromDioError(e).toString();
      callFailConnect(errorMessage);
      throw errorMessage;
    } catch (e) {
      callFailConnect(e.toString());
      rethrow;
    }
  }
}
