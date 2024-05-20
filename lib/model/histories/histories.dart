import 'package:equatable/equatable.dart';

class Histories extends Equatable {
  final int? chatgroupId;
  final String? chat;
  final DateTime? createTime;

  const Histories({this.chatgroupId, this.chat, this.createTime});

  factory Histories.fromJson(Map<String, dynamic> json) => Histories(
        chatgroupId: json['chatgroupId'] as int?,
        chat: json['chat'] as String?,
        createTime: json['createTime'] == null
            ? null
            : DateTime.parse(json['createTime'] as String),
      );

  Map<String, dynamic> toJson() => {
        'chatgroupId': chatgroupId,
        'chat': chat,
        'createTime': createTime?.toIso8601String(),
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [chatgroupId, chat, createTime];
}