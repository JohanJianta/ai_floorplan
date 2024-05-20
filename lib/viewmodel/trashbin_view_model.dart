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
      // Ambil data trashbin dari database dan filter yang sudah kedaluwarsa
      List<Floorplan> response = await _trashbinRepo.fetchFloorplanList();
      response = await _removeExpiredFloorplans(response);

      setFloorplanList(ApiResponse.completed(response));
    } catch (error) {
      setFloorplanList(ApiResponse.error(error.toString()));
    }
  }

  Future<String> restoreFloorplans(Set<Floorplan> floorplans) async {
    try {
      // Pulihkan floorplan berdasarkan daftar id floorplan
      String value = await _trashbinRepo.restoreFloorplans(_getFloorplanIds(floorplans));

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
      // Hapus permanen floorplan berdasarkan daftar id floorplan
      String value = await _trashbinRepo.permanentDeleteFloorplans(_getFloorplanIds(floorplans));

      // Hapus floorplan dari daftar floorplan
      floorplanList.data?.removeWhere((floorplan) => floorplans.contains(floorplan));

      notifyListeners();

      return value;
    } catch (error) {
      return error.toString();
    }
  }

  Future<List<Floorplan>> _removeExpiredFloorplans(List<Floorplan> floorplans) async {
    Set<Floorplan> expiredFloorplans = {};
    DateTime now = DateTime.now();

    for (var floorplan in floorplans) {
      if (floorplan.createTime == null) continue;

      DateTime limit = floorplan.createTime!.add(const Duration(days: 30));

      if (limit.difference(now).isNegative) {
        expiredFloorplans.add(floorplan);
      }
    }

    if (expiredFloorplans.isNotEmpty) {
      Set<int> floorplanIds = _getFloorplanIds(expiredFloorplans);

      // Hapus permanen floorplan yang sudah kedaluwarsa
      await _trashbinRepo.permanentDeleteFloorplans(floorplanIds);

      // Hapus floorplan dari daftar floorplan
      floorplans.removeWhere((floorplan) => expiredFloorplans.contains(floorplan));
    }

    return floorplans;
  }

  Set<int> _getFloorplanIds(Set<Floorplan> floorplans) {
    Set<int> floorplanIds = {};

    // Ambil daftar id floorplan
    for (var floorplan in floorplans) {
      if (floorplan.floorplanId != null) {
        floorplanIds.add(floorplan.floorplanId!);
      }
    }

    return floorplanIds;
  }
}
