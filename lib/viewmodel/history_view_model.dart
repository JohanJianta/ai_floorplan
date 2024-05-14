import 'dart:html';

import 'package:ai_floorplan_test/data/response/api_response.dart';
import 'package:ai_floorplan_test/model/floorplan.dart';
import 'package:ai_floorplan_test/model/histories/histories.dart';
import 'package:ai_floorplan_test/repository/history_repository.dart';
import 'package:flutter/material.dart';

class HistoryViewModel with ChangeNotifier {
  final _historyRepo = HistoryRepository();
  ApiResponse<List<Histories>> HistoryList = ApiResponse.loading();

  sethistoryList(ApiResponse<List<Histories>> response) {
    HistoryList = response;
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
