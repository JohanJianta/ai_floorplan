import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ai_floorplan_test/shared/shared.dart';
import 'package:ai_floorplan_test/data/app_exception.dart';
import 'package:ai_floorplan_test/data/network/base_api_services.dart';

class NetworkApiServices implements BaseApiServices {
  @override
  Future getGetApiResponse(String endpoint) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(Const.baseUrl + endpoint), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': Const.auth,
      });
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('Pastikan anda terhubung ke internet');
    } on TimeoutException {
      throw FetchDataException('Network request timed out');
    }

    return responseJson;
  }

  @override
  Future getPostApiResponse(String endpoint, data) async {
    PostResponse responseJson;
    try {
      final response = await http.post(
        Uri.parse(Const.baseUrl + endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Const.auth,
        },
        body: jsonEncode(data),
      );
      responseJson = PostResponse(
        body: returnResponse(response),
        headers: response.headers,
      );
    } on SocketException {
      throw NoInternetException('Pastikan anda terhubung ke internet');
    } on TimeoutException {
      throw FetchDataException('Network request timed out');
    }

    return responseJson;
  }

  @override
  Future getPutApiResponse(String endpoint, data) async {
    dynamic responseJson;
    try {
      final response = await http.put(
        Uri.parse(Const.baseUrl + endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Const.auth,
        },
        body: data != null ? jsonEncode(data) : null,
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('Pastikan anda terhubung ke internet');
    } on TimeoutException {
      throw FetchDataException('Network request timed out');
    }

    return responseJson;
  }

  @override
  Future getDeleteApiResponse(String endpoint) async {
    dynamic responseJson;
    try {
      final response = await http.delete(Uri.parse(Const.baseUrl + endpoint), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': Const.auth,
      });
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('Pastikan anda terhubung ke internet');
    } on TimeoutException {
      throw FetchDataException('Network request timed out');
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    dynamic responseJson = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson;
      case 400:
        throw BadRequestException(responseJson['messages'][0]);
      case 401:
        throw UnauthorizedException(responseJson['messages'][0]);
      case 403:
        throw ForbiddenException(responseJson['messages'][0]);
      case 404:
        throw NotFoundException(responseJson['messages'][0]);
      case 409:
        throw BadRequestException(responseJson['messages'][0]);
      case 500:
      default:
        throw FetchDataException('Error occured while communicating with server');
    }
  }
}

class PostResponse {
  final dynamic body;
  final Map<String, String> headers;

  PostResponse({required this.body, this.headers = const {}});
}
