import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class DioService {
  static const String apiProducts = "/products";
  static const String mockApi = "/a";
  static const String apiCategoryProducts = "/products/category/";
  static const String apiSearchProduct = "/products/search?q=";
  static Map<String, Object?> paramSearchProduct(String text) =>
      <String, Object?>{
        "q": text,
      };

  static final BaseOptions _dummyOption = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      baseUrl: "https://dummyjson.com",
      validateStatus: (statusCode) => statusCode! <= 201,
      receiveDataWhenStatusError: true,
      contentType: "application/json");

  static final BaseOptions _mockAPiOption = BaseOptions(
      connectTimeout: const Duration(seconds: 100),
      receiveTimeout: const Duration(seconds: 100),
      sendTimeout: const Duration(seconds: 100),
      baseUrl: "https://65cbb766efec34d9ed87fe33.mockapi.io",
      validateStatus: (statusCode) => statusCode! <= 201,
      receiveDataWhenStatusError: true,
      contentType: "application/json");

  static final dio = Dio(_mockAPiOption);
  static final dioDummy = Dio(_dummyOption);

  static Future<Object> getData(String api) async {
    try {
      Response response = await dio.get(api);
      return jsonEncode(response.data);
    } on DioException catch (e) {
      return e;
    }
  }

  static Future<Object> getDummyData(String api) async {
    try {
      Response response = await dioDummy.get(api);
      return jsonEncode(response.data);
    } on DioException catch (e) {
      return e;
    }
  }
}
