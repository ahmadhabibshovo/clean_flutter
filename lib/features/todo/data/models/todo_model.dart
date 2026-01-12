import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/todo.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
class TodoModel with _$TodoModel {
  const factory TodoModel({
    required String id,
    required String title,
    @Default('') String description,
    @Default(false) bool isCompleted,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
}

extension TodoModelMapping on TodoModel {
  TodoEntity toEntity() => TodoEntity(
    id: id,
    title: title,
    description: description,
    isCompleted: isCompleted,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static TodoModel fromEntity(TodoEntity entity) => TodoModel(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    isCompleted: entity.isCompleted,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
