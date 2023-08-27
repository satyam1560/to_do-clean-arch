// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_cleanarch/1_domain/entities/unique_id.dart';

class ToDoEntry {
  final String description;
  final bool isDone;
  final EntryId id;

  const ToDoEntry({
    required this.id,
    required this.description,
    required this.isDone,
  });

  factory ToDoEntry.empty() {
    return ToDoEntry(
      id: EntryId(),
      description: '',
      isDone: false,
    );
  }
}