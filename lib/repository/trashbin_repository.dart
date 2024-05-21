part of 'repository.dart';

class TrashbinRepository {
  Future<List<Floorplan>> fetchFloorplanList() async {
    try {
      dynamic response = await apiServices.getGetApiResponse('/user/${Const.userId}/trashbin');

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
      dynamic response = await apiServices.getPutApiResponse('/trashbin?floorplanIds=${floorplanIds.join(',')}', null);

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
      dynamic response = await apiServices.getDeleteApiResponse('/trashbin?floorplanIds=${floorplanIds.join(',')}');

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
