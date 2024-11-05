import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dispositivos_moveis_2024_2/models/room.dart';
import 'package:dispositivos_moveis_2024_2/controllers/active_project_controller.dart';
import 'package:dispositivos_moveis_2024_2/ui/widgets/bottom_sheet_widget.dart';
import 'package:dispositivos_moveis_2024_2/ui/widgets/confirm_dialog_widget.dart';
import 'package:dispositivos_moveis_2024_2/ui/widgets/empty_list_message_widget.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  late ActiveProjectController _controller;

  final _form = GlobalKey<FormState>();

  final _nameInputController = TextEditingController();

  void _onTileTap(Room room) {
    if (_controller.roomSelectionMode) {
      _controller.toggleRoomSelection(room);
    }
  }

  void _onTileLongPress(Room room) {
    if (_controller.roomSelectionMode) {
      return _controller.clearRoomSelection();
    }

    _controller.toggleRoomSelection(room);
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<ActiveProjectController>(context);

    return Scaffold(
      appBar: AppBar(
        leading: _buildAppBarLeading(),
        title: Text(_controller.project.name),
        actions: _buildAppBarActions(),
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

  Widget? _buildAppBarLeading() {
    return _controller.roomSelectionMode
        ? IconButton(
            onPressed: () => _controller.clearRoomSelection(),
            icon: const Icon(Icons.undo),
          )
        : null;
  }

  List<Widget> _buildAppBarActions() {
    final List<Widget> actions = [];

    if (_controller.roomSelectionMode) {
      actions.add(
        IconButton(
          onPressed: () => _showDeleteSelectedRooms(),
          icon: const Icon(Icons.delete),
        ),
      );
    }

    return actions;
  }

  Widget _buildRoomsList() {
    if (_controller.rooms.isEmpty) {
      return const EmptyListMessageWidget(
        title: "Looks like you didn't add any rooms yet.",
        subtitle: 'Add a new room to be able to upload test data.',
      );
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
      onLongPress: () => _onTileLongPress(room),
      onTap: () => _onTileTap(room),
      child: Ink(
        color: index % 2 != 0 ? primaryColor.withOpacity(0.2) : primaryColor.withOpacity(0.1),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          minLeadingWidth: 0,
          horizontalTitleGap: 10,
          leading: _buildListTileLeadingSelection(room),
          title: Text(room.name),
          trailing: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  IconButton(
                    onPressed: () => _showCreateOrRenameRoom(room),
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

  // Show or hide checkbox depending on "selectionMode"
  AnimatedContainer _buildListTileLeadingSelection(Room room) {
    return AnimatedContainer(
      margin: const EdgeInsets.all(0),
      height: double.infinity,
      width: _controller.roomSelectionMode ? 30 : 0,
      duration: Durations.short4,
      child: _controller.roomSelectionMode
          ? _controller.selectedRooms.contains(room)
              ? const Icon(Icons.check_box)
              : const Icon(Icons.check_box_outline_blank)
          : null,
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
                _controller.renameRoom(room.id, _nameInputController.text);
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

  Future<void> _showDeleteSelectedRooms() {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          title: 'Delete Rooms',
          contents: const [
            Icon(
              Icons.warning_rounded,
              size: 48,
            ),
            Text(
              "Are you sure you want to delete all selected rooms?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.fade,
            ),
            SizedBox(height: 15),
            Text(
              "All data associated with it will also be deleted.",
              textAlign: TextAlign.center,
            ),
          ],
          submitCallback: () {
            _controller.removeAllSelectedRooms();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
