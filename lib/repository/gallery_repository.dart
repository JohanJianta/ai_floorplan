import 'package:ai_floorplan_test/data/network/network_api_services.dart';
import 'package:ai_floorplan_test/model/floorplan.dart';
import 'package:ai_floorplan_test/shared/shared.dart';

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

  Future<String> deleteFloorplan(int floorplanId) async {
    try {
      dynamic response = await _apiServices.getDeleteApiResponse('/gallery/$floorplanId');

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
