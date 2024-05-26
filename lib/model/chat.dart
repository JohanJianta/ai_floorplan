import 'package:equatable/equatable.dart';

import 'floorplan.dart';

class Chat extends Equatable {
  final String? chat;
  final int? userId;
  final int? chatgroupId;
  final List<Floorplan>? floorplans;

  const Chat({this.chat, this.userId, this.chatgroupId, this.floorplans});

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chat: json['chat'] as String?,
        userId: json['userId'] as int?,
        chatgroupId: json['chatgroupId'] as int?,
        floorplans: (json['floorplans'] as List<dynamic>?)?.map((floorplanJson) => Floorplan.fromJson(floorplanJson as Map<String, dynamic>)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'chat': chat,
        'userId': userId,
        'chatgroupId': chatgroupId,
        'floorplans': floorplans?.map((floorplan) => floorplan.toJson()).toList(),
      };

  Chat copyWith({
    String? chat,
    int? userId,
    int? chatgroupId,
    List<Floorplan>? floorplans,
  }) {
    return Chat(
      chat: chat ?? this.chat,
      userId: userId ?? this.userId,
      chatgroupId: chatgroupId ?? this.chatgroupId,
      floorplans: floorplans ?? this.floorplans,
    );
  }

  @override
  List<Object?> get props => [chat, userId, chatgroupId, floorplans];
}
