import 'package:ai_floorplan_test/data/response/status.dart';
import 'package:ai_floorplan_test/model/chat.dart';
import 'package:ai_floorplan_test/model/history.dart';
import 'package:ai_floorplan_test/model/floorplan.dart';
import 'package:ai_floorplan_test/repository/repository.dart';
import 'package:ai_floorplan_test/data/response/api_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'gallery_view_model.dart';
part 'trashbin_view_model.dart';
part 'history_view_model.dart';
part 'chat_view_model.dart';

bool isToday(DateTime? dateTime) {
  if (dateTime == null) return false;
  final now = DateTime.now();
  return dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day;
}

bool isPrevious7Days(DateTime? dateTime, DateTime previous7Days, DateTime now) {
  if (dateTime == null) return false;
  return dateTime.isAfter(previous7Days) && dateTime.isBefore(now);
}

String getMonthYear(DateTime? dateTime) {
  if (dateTime == null) return '';
  return DateFormat('MMMM yyyy').format(dateTime);
}
