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
}
