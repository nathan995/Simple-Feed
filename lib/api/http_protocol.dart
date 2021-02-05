import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HttpProtocol {
  Dio dio = new Dio();

  Future get({@required String path}) async {
    return dio.get(
      path,
    );
  }

  Future put({@required String path, Map<String, dynamic> params}) async {
    return dio.put(
      path,
      queryParameters: params,
    );
  }

  Future post({@required String path, Map<String, dynamic> params}) async {
    return dio.post(
      path,
      queryParameters: params,
    );
  }

  Future postFiles({@required String path, FormData data}) async {
    return dio.post(
      path,
      data: data,
    );
  }
}
