import 'package:ai_floorplan_test/data/network/network_api_services.dart';
import 'package:ai_floorplan_test/model/floorplan.dart';
import 'package:ai_floorplan_test/model/histories/histories.dart';
import 'package:ai_floorplan_test/shared/shared.dart';

class HistoryRepository {
  final _apiServices = NetworkApiServices();

  Future<List<Histories>> fetchHistoryList() async {
    try {
      dynamic response =
          await _apiServices.getGetApiResponse('/user/${Const.userId}/history');

      List<Histories> result = [];

      if (response['success']) {
        result = (response['payload']['histories'] as List)
            .map((e) => Histories.fromJson(e))
            .toList();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
