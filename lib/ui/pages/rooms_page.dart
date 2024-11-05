import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dispositivos_moveis_2024_2/models/room.dart';
import 'package:dispositivos_moveis_2024_2/ui/widgets/bottom_sheet_widget.dart';
import 'package:dispositivos_moveis_2024_2/controllers/active_project_controller.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  late ActiveProjectController _controller;

  final _form = GlobalKey<FormState>();

  final _nameInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<ActiveProjectController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_controller.project.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateOrRenameRoom(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: _buildRoomsList(),
    );
  }

  Widget _buildRoomsList() {
    if (_controller.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _controller.rooms.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildRoomsListTile(_controller.rooms[index], index);
      },
    );
  }

  Widget _buildRoomsListTile(Room room, int index) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onLongPress: () => {},
      onTap: () => {},
      child: Ink(
        color: index % 2 != 0 ? primaryColor.withOpacity(0.2) : primaryColor.withOpacity(0.1),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          minLeadingWidth: 0,
          horizontalTitleGap: 10,
          leading: null,
          title: Text(room.name),
          // subtitle: Text("Modified ${room.updatedAtTimeAgo}"),
          trailing: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  IconButton(
                    onPressed: () => {},
                    padding: const EdgeInsets.all(16),
                    icon: const Icon(Icons.mode_edit),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form _buildFormName() {
    return Form(
      key: _form,
      child: TextFormField(
        controller: _nameInputController,
        decoration: const InputDecoration(
          labelText: 'Room name',
          border: OutlineInputBorder(),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
        ],
        validator: (value) {
          if (value!.length < 3 || value.length > 20) {
            return "The room name should be between 3 to 20 characters.";
          }

          return null;
        },
      ),
    );
  }

  Future<void> _showCreateOrRenameRoom([Room? room]) {
    final title = room != null ? 'Rename Room' : 'Create Room';

    if (room != null) {
      _nameInputController.text = room.name;
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return BottomSheetWidget(
          title: title,
          content: _buildFormName(),
          submitCallback: () {
            if (_form.currentState!.validate()) {
              if (room != null) {
                // _controller.renameRoom(room.id, _nameInputController.text);
              } else {
                _controller.createRoom(_nameInputController.text);
              }

              Navigator.of(context).pop();
            }
          },
        );
      },
    ).whenComplete(() {
      _nameInputController.clear();
    });
  }
}
