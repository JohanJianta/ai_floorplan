import 'package:ai_floorplan_test/data/response/api_response.dart';
import 'package:ai_floorplan_test/model/floorplan.dart';
import 'package:ai_floorplan_test/repository/gallery_repository.dart';
import 'package:flutter/material.dart';

class GalleryViewModel with ChangeNotifier {
  final _galleryRepo = GalleryRepository();
  ApiResponse<List<Floorplan>> floorplanList = ApiResponse.loading();

  setFloorplanList(ApiResponse<List<Floorplan>> response) {
    floorplanList = response;
    notifyListeners();
  }

  Future<void> fetchFloorplanList() async {
    setFloorplanList(ApiResponse.loading());
    _galleryRepo.fetchFloorplanList().then((value) {
      setFloorplanList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setFloorplanList(ApiResponse.error(error.toString()));
    });
  }
}
