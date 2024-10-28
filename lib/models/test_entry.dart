typedef TestEntryData = ({
  double signalStrength_2g,
  double speed_2g,
  double signalStrength_5g,
  double speed_5g,
});

class TestEntry {
  final DateTime _createdAt = DateTime.now();
  DateTime _updatedAt = DateTime.now();
  TestEntryData _data;

  TestEntry(this._data);

  DateTime get createdAt => _createdAt;

  DateTime get updatedAt => _updatedAt;

  TestEntryData get data => _data;

  void update(TestEntryData data) {
    _data = data;
    _updatedAt = DateTime.now();
  }
}
