import 'package:dispositivos_moveis_2024_2/models/room.dart';
import 'package:dispositivos_moveis_2024_2/providers/rooms_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../widgets/bottom_sheet_widget.dart';
import 'active_room_page.dart';
//é onde mostra os comodos que vai ser cadastrado (Room name)

class RoomsPage extends StatefulWidget {
  final Project project;

  const RoomsPage({
    super.key,
    required this.project,
  });

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool _onSelectionMode = false;

  late RoomsProvider _roomsProvider;

  late List<Room>  _rooms;

  final List<Room> _selected = [];

  final _form = GlobalKey<FormState>();

  final _name = TextEditingController();

  void _clearSelectionMode() {
    setState(() {
      _onSelectionMode = false;
      _selected.clear();
    });
  }

  void _createRoom() {
    context.read<RoomsProvider>().add(_name.text);
  }

  void _renameRoom(int roomId) {
    context.read<RoomsProvider>().rename(roomId, _name.text);
  }

  void _removeAllSelected() {
    context.read<RoomsProvider>().removeAll(_selected);

    _clearSelectionMode();
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _roomsProvider = context.watch<RoomsProvider>();
    // _projects = _provider.getFilteredList(_searchQuery);
    _rooms = _roomsProvider.rooms;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: _buildAppBarLeading(),
        actions: _buildAppBarActions(),
        title: const Text('Rooms'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateOrRenameRoom(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: _rooms.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRoomListTile(_rooms[index], index);
        },
      ),
    );
  }

  Widget? _buildAppBarLeading() {
    return _onSelectionMode
        ? IconButton(
      onPressed: () => _clearSelectionMode(),
      icon: const Icon(Icons.undo),
    )
        : null;
  }

  List<Widget> _buildAppBarActions() {
    final List<Widget> actions = [];

    if (_onSelectionMode) {
      actions.add(
        IconButton(
          onPressed: () => _showDeleteSelectedRooms(),
          icon: const Icon(Icons.delete),
        ),
      );
    }

    return actions;
  }

  Widget _buildRoomListTile(Room room, int index) {
    final primaryColor = Theme
        .of(context)
        .colorScheme
        .primary;

    return InkWell(
      onLongPress: () {
        setState(() {
          if (!_onSelectionMode) {
            _onSelectionMode = true;

            if (_selected.contains(room)) {
              _selected.remove(room);
            } else {
              _selected.add(room);
            }
          } else {
            _clearSelectionMode();
          }
        });
      },
      onTap: () {
        if (!_onSelectionMode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActiveRoomPage(room: room),
            ),
          );
        } else {
          setState(() {
            if (_selected.contains(room)) {
              _selected.remove(room);
            } else {
              _selected.add(room);
            }
          });
        }
      },
      child: Ink(
        color: index % 2 != 0
            ? primaryColor.withOpacity(0.2)
            : primaryColor.withOpacity(0.1),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          minLeadingWidth: 0,
          horizontalTitleGap: 10,
          leading: _buildListTileLeadingSelection(room),
          title: Text(room.name),
          subtitle: Text("Modified ${room.updatedAtTimeAgo}"),
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
                  // IconButton(
                  //   onPressed: () => _showDeleteProject(project),
                  //   padding: const EdgeInsets.all(16),
                  //   icon: const Icon(Icons.delete),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer _buildListTileLeadingSelection(Room room) {
    return AnimatedContainer(
      margin: const EdgeInsets.all(0),
      height: double.infinity,
      width: _onSelectionMode ? 30 : 0,
      duration: Durations.short4,
      child: _onSelectionMode
          ? _selected.contains(room)
          ? const Icon(Icons.check_box)
          : const Icon(Icons.check_box_outline_blank)
          : null,
    );
  }

  Form _buildFormName() {
    return Form(
      key: _form,
      child: TextFormField(
        controller: _name,
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
      _name.text = room.name;
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
                _renameRoom(room.id);
              } else {
                _createRoom();
              }

              Navigator.of(context).pop();
            }
          },
        );
      },
    ).whenComplete(() {
      _name.clear();
    });
  }

  Future<void> _showDeleteSelectedRooms() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Rooms',
            textAlign: TextAlign.center,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_rounded,
                size: 48,
              ),
              Text(
                "Are you sure you want to delete all rooms?",
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
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            OutlinedButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FilledButton(
              style: const ButtonStyle(),
              onPressed: () {
                _removeAllSelected();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
