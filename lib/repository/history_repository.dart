part of 'repository.dart';

class HistoryRepository {
  Future<List<History>> fetchHistoryList() async {
    try {
      dynamic response = await apiServices.getGetApiResponse('/user/${Const.userId}/history');

      List<History> result = [];

      if (response['success']) {
        result = (response['payload']['histories'] as List).map((e) => History.fromJson(e)).toList();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteHistory(int chatgroupId) async {
    try {
      dynamic response = await apiServices.getDeleteApiResponse('/chat/$chatgroupId');

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
