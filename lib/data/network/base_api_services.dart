abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String endpoint);
  Future<dynamic> getPostApiResponse(String url, dynamic data);
  Future<dynamic> getDeleteApiResponse(String url, dynamic data);
}
