import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispositivos_moveis_2024_2/models/room.dart';
import 'package:dispositivos_moveis_2024_2/controllers/active_project_controller.dart';
import 'package:dispositivos_moveis_2024_2/models/test_entry.dart';

class TestEntryFormPage extends StatefulWidget {
  final List<Room> rooms;

  const TestEntryFormPage({super.key, required this.rooms});

  @override
  State<TestEntryFormPage> createState() => _TestEntryFormPageState();
}

class _TestEntryFormPageState extends State<TestEntryFormPage> {
  final _form = GlobalKey<FormState>();
  final _room = TextEditingController();
  final _signalStrength2g = TextEditingController();
  final _signalStrength5g = TextEditingController();
  final _speed2g = TextEditingController();
  final _speed5g = TextEditingController();

  bool loading = false;

  late Room? selectedRoom;

  @override
  void initState() {
    selectedRoom = widget.rooms.first;
    super.initState();
  }

  void _submitForm() {
    // TODO: validate fields
    final controller = context.read<ActiveProjectController>();

    if (selectedRoom != null) {
      // TODO: refactor to be able to handle async submit

      controller.createTestEntry(
        selectedRoom!.id,
        (
          signalStrength_2g: double.parse(_signalStrength2g.text),
          signalStrength_5g: double.parse(_signalStrength5g.text),
          speed_2g: double.parse(_speed2g.text),
          speed_5g: double.parse(_speed5g.text),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New test entry'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: _buildForm(),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _form,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Text(
                'Room',
                style: TextStyle(fontSize: 24),
              ),
            ),
            _buildDropdownRooms(),
            const Padding(
              padding: EdgeInsets.only(top: 24.0, bottom: 12.0),
              child: Text(
                '2,4 GHz Channel',
                style: TextStyle(fontSize: 24),
              ),
            ),
            _buildFormInput(
              label: 'Signal strength (dBm)',
              controller: _signalStrength2g,
              validator: (value) {
                return null;
              },
            ),
            _buildFormInput(
              label: 'Speed (Mbps)',
              controller: _speed2g,
              validator: (value) {
                return null;
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 24.0, bottom: 12.0),
              child: Text(
                '5 GHz Channel',
                style: TextStyle(fontSize: 24),
              ),
            ),
            _buildFormInput(
              label: 'Signal strength (dBm)',
              controller: _signalStrength5g,
              validator: (value) {
                return null;
              },
            ),
            _buildFormInput(
              label: 'Speed (Mbps)',
              controller: _speed5g,
              validator: (value) {
                return null;
              },
            ),
            _buildFormButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownRooms() {
    return DropdownMenu<Room>(
      initialSelection: widget.rooms[0],
      expandedInsets: const EdgeInsets.only(left: 0, right: 0),
      controller: _room,
      hintText: 'Select the room for this entry',
      onSelected: (Room? room) {
        setState(() {
          selectedRoom = room;
        });
      },
      dropdownMenuEntries: widget.rooms.map<DropdownMenuEntry<Room>>((Room room) {
        return DropdownMenuEntry<Room>(
          value: room,
          label: room.name,
        );
      }).toList(),
    );
  }

  Widget _buildFormInput({
    required String label,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildFormButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
          FilledButton(
            onPressed: () => _submitForm(),
            style: const ButtonStyle(),
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
