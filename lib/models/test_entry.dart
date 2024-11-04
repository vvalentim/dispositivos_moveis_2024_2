typedef TestEntryData = ({
  double signalStrength_2g,
  double speed_2g,
  double signalStrength_5g,
  double speed_5g,
});

class TestEntry {
  final int id;

  final int projectId;

  final int roomId;

  final DateTime createdAt;

  final DateTime updatedAt;

  final TestEntryData data;

  TestEntry({
    required this.id,
    required this.projectId,
    required this.roomId,
    required this.createdAt,
    required this.updatedAt,
    required this.data,
  });

  TestEntry copyWith({
    int? id,
    int? roomId,
    int? projectId,
    DateTime? createdAt,
    DateTime? updatedAt,
    TestEntryData? data,
  }) {
    return TestEntry(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      projectId: projectId ?? this.projectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      data: data ?? this.data,
    );
  }
}
