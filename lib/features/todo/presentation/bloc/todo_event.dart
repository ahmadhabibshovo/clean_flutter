import 'package:equatable/equatable.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class TodoLoadRequested extends TodoEvent {
  const TodoLoadRequested();
}

class TodoAddRequested extends TodoEvent {
  final String title;
  final String description;

  const TodoAddRequested({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

class TodoToggleRequested extends TodoEvent {
  final String id;

  const TodoToggleRequested({required this.id});

  @override
  List<Object?> get props => [id];
}
