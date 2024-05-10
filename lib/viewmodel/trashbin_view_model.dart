part of 'view_model.dart';

class TrashbinViewModel with ChangeNotifier {
  final TrashbinRepository _trashbinRepo = TrashbinRepository();
  ApiResponse<List<Floorplan>> floorplanList = ApiResponse.notStarted();

  void setFloorplanList(ApiResponse<List<Floorplan>> response) {
    floorplanList = response;
    notifyListeners();
  }

  Future<void> fetchCategorizedFloorplans() async {
    setFloorplanList(ApiResponse.loading());

    try {
      // Ambil data trashbin dari database
      List<Floorplan> response = await _trashbinRepo.fetchFloorplanList();
      setFloorplanList(ApiResponse.completed(response));
    } catch (error) {
      setFloorplanList(ApiResponse.error(error.toString()));
    }
  }

  Future<String> restoreFloorplans(Set<Floorplan> floorplans) async {
    try {
      Set<int> floorplanIds = {};

      // Ambil daftar floorplan id
      for (var floorplan in floorplans) {
        if (floorplan.floorplanId != null) {
          floorplanIds.add(floorplan.floorplanId!);
        }
      }

      String value = await _trashbinRepo.restoreFloorplans(floorplanIds);

      // Hapus floorplan dari daftar floorplan
      floorplanList.data?.removeWhere((floorplan) => floorplans.contains(floorplan));

      notifyListeners();

      return value;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> deleteFloorplans(Set<Floorplan> floorplans) async {
    try {
      Set<int> floorplanIds = {};

      // Ambil daftar floorplan id
      for (var floorplan in floorplans) {
        if (floorplan.floorplanId != null) {
          floorplanIds.add(floorplan.floorplanId!);
        }
      }

      String value = await _trashbinRepo.permanentDeleteFloorplans(floorplanIds);

      // Hapus floorplan dari daftar floorplan
      floorplanList.data?.removeWhere((floorplan) => floorplans.contains(floorplan));

      notifyListeners();

      return value;
    } catch (error) {
      return error.toString();
    }
  }
}
