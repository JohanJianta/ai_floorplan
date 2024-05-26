part of 'view_model.dart';

class HistoryViewModel with ChangeNotifier {
  final _historyRepo = HistoryRepository();
  ApiResponse<List<History>> historyList = ApiResponse.loading();

  sethistoryList(ApiResponse<List<History>> response) {
    historyList = response;
    notifyListeners();
  }

  Future<void> fetchhistoryList() async {
    sethistoryList(ApiResponse.loading());
    _historyRepo.fetchHistoryList().then((value) {
      sethistoryList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      sethistoryList(ApiResponse.error(error.toString()));
    });
  }

  Future<String> removeHistory(int chatgroupId) async {
    try {
      String value = await _historyRepo.deleteHistory(chatgroupId);

      // Hapus history dari daftar history
      historyList.data?.removeWhere((history) => history.chatgroupId == chatgroupId);

      notifyListeners();

      return value;
    } catch (error) {
      rethrow;
    }
  }
}
