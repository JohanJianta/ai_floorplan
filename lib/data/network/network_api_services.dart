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
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network request timed out');
    }

    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, data) {
    throw UnimplementedError();
  }

  @override
  Future getDeleteApiResponse(String url, data) {
    throw UnimplementedError();
  }

  dynamic returnResponse(http.Response response) {
    dynamic responseJson = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 400:
        throw BadRequestException(responseJson['messages'].toString());
      case 401:
        throw UnauthorizedException(responseJson['messages'][0]);
      case 403:
        throw ForbiddenException(responseJson['messages'][0]);
      case 404:
        throw UnauthorizedException(responseJson['messages'][0]);
      case 500:
      default:
        throw FetchDataException('Error occured while communicating with server');
    }
  }
}
