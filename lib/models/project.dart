import 'package:timeago/timeago.dart' as timeago;

class Project {
  final int id;

  final DateTime createdAt;

  final DateTime updatedAt;

  final String name;

  String get updatedAtTimeAgo => timeago.format(updatedAt);

  Project({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
  });

  Project copyWith({
    DateTime? updatedAt,
    String? name,
  }) {
    return Project(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
    );
  }
}
