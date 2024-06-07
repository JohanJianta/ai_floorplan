part of 'view_model.dart';

class GalleryViewModel with ChangeNotifier {
  final GalleryRepository _galleryRepo = GalleryRepository();
  ApiResponse<List<CategorizedFloorplans>> categoryList = ApiResponse.notStarted();

  void setFloorplanList(ApiResponse<List<CategorizedFloorplans>> response) {
    categoryList = response;
    notifyListeners();
  }

  Future<void> fetchCategorizedFloorplans() async {
    setFloorplanList(ApiResponse.loading());

    try {
      // Ambil data gallery dari database, kemudian sortir sebelum dikembalikan
      List<Floorplan> response = await _galleryRepo.fetchFloorplanList();
      setFloorplanList(ApiResponse.completed(_categorizeFloorplans(response)));
    } catch (error) {
      setFloorplanList(ApiResponse.error(error.toString()));
    }
  }

  Future<String> deleteFloorplans(Set<Floorplan> floorplans) async {
    try {
      Set<int> floorplanIds = {};

      // Ambil daftar id floorplan
      for (var floorplan in floorplans) {
        if (floorplan.floorplanId != null) {
          floorplanIds.add(floorplan.floorplanId!);
        }
      }

      // Hapus floorplan dari galeri berdasarkan daftar id floorplan
      String value = await _galleryRepo.deleteFloorplans(floorplanIds);

      // Hapus floorplan dari daftar floorplan
      categoryList.data?.forEach((category) {
        category.floorplans.removeWhere((floorplan) => floorplans.contains(floorplan));
      });

      // Hapus kategori yang tidak memiliki floorplan
      categoryList.data?.removeWhere((category) => category.floorplans.isEmpty);

      notifyListeners();

      return value;
    } catch (error) {
      return error.toString();
    }
  }

  List<CategorizedFloorplans> _categorizeFloorplans(List<Floorplan> floorplans) {
    final now = DateTime.now();
    final previous7Days = now.subtract(const Duration(days: 7));

    Map<String, List<Floorplan>> categorizedMap = {};

    // Sortir floorplan berdasarkan kategori
    for (var floorplan in floorplans) {
      if (isToday(floorplan.createTime)) {
        _addToCategory(categorizedMap, 'Today', floorplan);
      } else if (isPrevious7Days(floorplan.createTime, previous7Days, now)) {
        _addToCategory(categorizedMap, 'Previous 7 Days', floorplan);
      } else {
        final dateLabel = getMonthYear(floorplan.createTime);
        _addToCategory(categorizedMap, dateLabel, floorplan);
      }
    }

    return categorizedMap.entries.map((entry) => CategorizedFloorplans(entry.key, entry.value)).toList();
  }

  // Masukkan floorplan ke dalam kategori
  void _addToCategory(Map<String, List<Floorplan>> categorizedMap, String category, Floorplan floorplan) {
    categorizedMap.putIfAbsent(category, () => []);
    categorizedMap[category]!.add(floorplan);
  }
}

class CategorizedFloorplans {
  final String label;
  final List<Floorplan> floorplans;

  CategorizedFloorplans(this.label, this.floorplans);
}
