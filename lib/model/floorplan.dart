import 'package:equatable/equatable.dart';

class Floorplan extends Equatable {
  final int? floorplanId;
  final String? imageData;
  final String? prompt;
  final DateTime? createTime;

  const Floorplan({
    this.floorplanId,
    this.imageData,
    this.prompt,
    this.createTime,
  });

  factory Floorplan.fromJson(Map<String, dynamic> json) => Floorplan(
        floorplanId: json['floorplanId'] as int?,
        imageData: json['imageData'] as String?,
        prompt: json['prompt'] as String?,
        createTime: json['createTime'] == null
            ? null
            : DateTime.parse(json['createTime'] as String),
      );

  Map<String, dynamic> toJson() => {
        'floorplanId': floorplanId,
        'imageData': imageData,
        'prompt': prompt,
        'createTime': createTime?.toIso8601String(),
      };

  Floorplan copyWith({
    int? floorplanId,
    String? imageData,
    String? prompt,
    DateTime? createTime,
  }) {
    return Floorplan(
      floorplanId: floorplanId ?? this.floorplanId,
      imageData: imageData ?? this.imageData,
      prompt: prompt ?? this.prompt,
      createTime: createTime ?? this.createTime,
    );
  }

  @override
  List<Object?> get props => [floorplanId, imageData, prompt, createTime];
}
