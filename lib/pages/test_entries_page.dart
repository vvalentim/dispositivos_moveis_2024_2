import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    const PlaceholderPage(title: "Rooms"),
    const TestEntriesPage(),
    const PlaceholderPage(title: "Reports"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room),
            label: "Rooms",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Test Entries",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: "Reports",
          ),
        ],
      ),
    );
  }
}

class TestEntriesPage extends StatefulWidget {
  const TestEntriesPage({super.key});

  @override
  State<TestEntriesPage> createState() => _TestEntriesPageState();
}

class _TestEntriesPageState extends State<TestEntriesPage> {
  final List<DisplayData> _displayDataList = [];

  void _navigateToAddForm() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddFormPage(
          onSave: (data) {
            setState(() {
              _displayDataList.add(data);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Entries'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddForm,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: _displayDataList.length,
        itemBuilder: (context, index) {
          final data = _displayDataList[index];
          return DisplayDataCard(data: data);
        },
      ),
    );
  }
}

class AddFormPage extends StatelessWidget {
  final Function(DisplayData) onSave;

  const AddFormPage({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final TextEditingController roomController = TextEditingController();
    final TextEditingController signal24Controller = TextEditingController();
    final TextEditingController speed24Controller = TextEditingController();
    final TextEditingController signal5Controller = TextEditingController();
    final TextEditingController speed5Controller = TextEditingController();
    final TextEditingController networkNameController = TextEditingController();
    final TextEditingController noiseValueController = TextEditingController();

    bool _areAllFieldsFilled() {
      return roomController.text.isNotEmpty &&
          signal24Controller.text.isNotEmpty &&
          speed24Controller.text.isNotEmpty &&
          signal5Controller.text.isNotEmpty &&
          speed5Controller.text.isNotEmpty &&
          networkNameController.text.isNotEmpty &&
          noiseValueController.text.isNotEmpty;
    }

    void _saveData() {
      if (_areAllFieldsFilled()) {
        final newData = DisplayData(
          room: roomController.text,
          signal24: signal24Controller.text,
          speed24: speed24Controller.text,
          signal5: signal5Controller.text,
          speed5: speed5Controller.text,
          networkName: networkNameController.text,
          noiseValue: noiseValueController.text,
        );

        onSave(newData);
        Navigator.of(context).pop();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Warning'),
              content: const Text('Please fill in all fields.'),
              actions: [
                TextButton(
                  onPressed: () {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Test Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Room", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(controller: roomController),
              const SizedBox(height: 16),
              const Text("2.4 GHz Channel", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(controller: signal24Controller, decoration: const InputDecoration(labelText: "Signal strength")),
              TextField(controller: speed24Controller, decoration: const InputDecoration(labelText: "Speed")),
              const SizedBox(height: 16),
              const Text("5 GHz Channel", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(controller: signal5Controller, decoration: const InputDecoration(labelText: "Signal strength")),
              TextField(controller: speed5Controller, decoration: const InputDecoration(labelText: "Speed")),
              const SizedBox(height: 16),
              const Text("Interference", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(controller: networkNameController, decoration: const InputDecoration(labelText: "Network name")),
              TextField(controller: noiseValueController, decoration: const InputDecoration(labelText: "Noise value (dBm)")),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _saveData,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayData {
  final String room;
  final String signal24;
  final String speed24;
  final String signal5;
  final String speed5;
  final String networkName;
  final String noiseValue;

  DisplayData({
    required this.room,
    required this.signal24,
    required this.speed24,
    required this.signal5,
    required this.speed5,
    required this.networkName,
    required this.noiseValue,
  });
}

class DisplayDataCard extends StatelessWidget {
  final DisplayData data;

  const DisplayDataCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Room: ${data.room}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10, width: 10,),
            Row(
              children: [
                Expanded(
                  child: _buildNestedCard("2.4 GHz", [
                    _buildDataRow("Signal strength", data.signal24,),
                    _buildDataRow("Speed", data.speed24),
                  ]),
                ),
                const SizedBox(width: 10,height: 10,),
                Expanded(
                  child: _buildNestedCard("5 GHz", [
                    _buildDataRow("Signal strength", data.signal5),
                    _buildDataRow("Speed", data.speed5),
                  ]),
                ),
                const SizedBox(width: 10,height: 10),
                Expanded(
                  child: _buildNestedCard("Noise", [
                    _buildDataRow("Network name:", data.networkName),
                    _buildDataRow("Noise (dBm):", data.noiseValue),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNestedCard(String title, List<Widget> children) {
    return Card(
      color: Colors.grey[400],
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black87)),
          Text(value, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('$title Content'),
      ),
    );
  }
}
