abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String endpoint);
  Future<dynamic> getPostApiResponse(String endpoint, dynamic data);
  Future<dynamic> getPutApiResponse(String endpoint, dynamic data);
  Future<dynamic> getDeleteApiResponse(String endpoint);
}
