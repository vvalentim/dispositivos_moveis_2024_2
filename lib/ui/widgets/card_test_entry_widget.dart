import 'package:flutter/material.dart';
import 'package:dispositivos_moveis_2024_2/controllers/active_project_controller.dart';
import 'package:dispositivos_moveis_2024_2/models/test_entry.dart';

class CardTestEntryWidget extends StatelessWidget {
  final TestEntry entry;

  final ActiveProjectController controller;

  const CardTestEntryWidget({
    super.key,
    required this.entry,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      color: primaryColor.withOpacity(0.1),
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8, right: 12, left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildDataRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final roomName = controller.getRoomName(entry.roomId) ?? 'Room name';
    final isoEntryDate = 'Entry date';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.meeting_room,
              size: 36,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roomName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  isoEntryDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          // const Icon(
          //   Icons.menu_open,
          //   size: 32,
          // ),
        ],
      ),
    );
  }

  Row _buildDataRow() {
    return Row(
      children: [
        _buildDataColumn(
          title: '2,4 GHz',
          firstLabel: 'Signal strength',
          firstDataValue: '${entry.data.signalStrength_2g.toString()} dBm',
          secondLabel: 'Speed',
          secondDataValue: '${entry.data.speed_2g.toString()} Mbps',
        ),
        _buildDataColumn(
          title: '5 GHz',
          firstLabel: 'Signal strength',
          firstDataValue: '${entry.data.signalStrength_5g.toString()} dBm',
          secondLabel: 'Speed',
          secondDataValue: '${entry.data.speed_5g.toString()} Mbps',
        ),
      ],
    );
  }

  Expanded _buildDataColumn({
    required String title,
    required String firstLabel,
    required String firstDataValue,
    required String secondLabel,
    required String secondDataValue,
  }) {
    return Expanded(
      child: Card(
        color: Colors.black12,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(6, 6)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                firstLabel,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              Text(
                firstDataValue,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                secondLabel,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              Text(
                secondDataValue,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
