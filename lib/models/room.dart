class Room {
  final int id;

  final int projectId;

  final DateTime createdAt;

  final DateTime updatedAt;

  final String name;

  Room({
    required this.id,
    required this.projectId,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
  });

  Room copyWith({
    int? id,
    int? projectId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
  }) {
    return Room(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
    );
  }
}
