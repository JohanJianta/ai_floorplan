part of 'repository.dart';

class TrashbinRepository {
  final _apiServices = NetworkApiServices();

  Future<List<Floorplan>> fetchFloorplanList() async {
    try {
      dynamic response = await _apiServices.getGetApiResponse('/user/${Const.userId}/trashbin');

      List<Floorplan> result = [];

      if (response['success']) {
        result = (response['payload']['floorplans'] as List).map((e) => Floorplan.fromJson(e)).toList();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> restoreFloorplans(Set<int> floorplanIds) async {
    try {
      dynamic response = await _apiServices.getPutApiResponse('/trashbin?floorplanIds=${floorplanIds.join(',')}', null);

      String result = '';

      if (response['success']) {
        result = response['messages'][0].toString();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> permanentDeleteFloorplans(Set<int> floorplanIds) async {
    try {
      dynamic response = await _apiServices.getDeleteApiResponse('/trashbin?floorplanIds=${floorplanIds.join(',')}');

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
