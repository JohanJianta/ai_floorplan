part of 'repository.dart';

class GalleryRepository {
  final _apiServices = NetworkApiServices();

  Future<List<Floorplan>> fetchFloorplanList() async {
    try {
      dynamic response = await _apiServices.getGetApiResponse('/user/${Const.userId}/gallery');

      List<Floorplan> result = [];

      if (response['success']) {
        result = (response['payload']['floorplans'] as List).map((e) => Floorplan.fromJson(e)).toList();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteFloorplans(Set<int> floorplanIds) async {
    try {
      dynamic response = await _apiServices.getDeleteApiResponse('/gallery?floorplanIds=${floorplanIds.join(',')}');

      String result = '';

      if (response['success']) {
        result = response['messages'][0].toString();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
