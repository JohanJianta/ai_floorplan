part of 'view_model.dart';

class HistoryViewModel with ChangeNotifier {
  final _historyRepo = HistoryRepository();
  ApiResponse<List<CategorizedHistory>> response = ApiResponse.loading();

  sethistoryList(ApiResponse<List<CategorizedHistory>> result) {
    response = result;
    notifyListeners();
  }

  Future<void> fetchhistoryList() async {
    sethistoryList(ApiResponse.loading());
    _historyRepo.fetchHistoryList().then((value) {
      sethistoryList(ApiResponse.completed(_categorizeHistories(value)));
    }).onError((error, stackTrace) {
      sethistoryList(ApiResponse.error(error.toString()));
    });
  }

  Future<String> removeHistory(int chatgroupId) async {
    try {
      String value = await _historyRepo.deleteHistory(chatgroupId);

      // Hapus history dari daftar history
      response.data?.forEach((category) {
        category.histories.removeWhere((history) => history.chatgroupId == chatgroupId);
      });

      // Hapus kategori yang tidak memiliki history
      response.data?.removeWhere((category) => category.histories.isEmpty);

      notifyListeners();

      return value;
    } catch (error) {
      rethrow;
    }
  }

  List<CategorizedHistory> _categorizeHistories(List<History> histories) {
    final now = DateTime.now();
    final previous7Days = now.subtract(const Duration(days: 7));

    Map<String, List<History>> categorizedMap = {};

    // Sortir history berdasarkan kategori
    for (var history in histories) {
      if (isToday(history.createTime)) {
        _addToCategory(categorizedMap, 'Today', history);
      } else if (isPrevious7Days(history.createTime, previous7Days, now)) {
        _addToCategory(categorizedMap, 'Previous 7 Days', history);
      } else {
        final dateLabel = getMonthYear(history.createTime);
        _addToCategory(categorizedMap, dateLabel, history);
      }
    }

    return categorizedMap.entries.map((entry) => CategorizedHistory(entry.key, entry.value)).toList();
  }

  // Masukkan floorplan ke dalam kategori
  void _addToCategory(Map<String, List<History>> categorizedMap, String category, History history) {
    categorizedMap.putIfAbsent(category, () => []);
    categorizedMap[category]!.add(history);
  }
}

class CategorizedHistory {
  final String label;
  final List<History> histories;

  CategorizedHistory(this.label, this.histories);
}
