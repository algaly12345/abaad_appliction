import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdvantagesList(),
    );
  }
}

class Advantage {
  final int id;
  final String name;

  Advantage({@required this.id, @required this.name});

  factory Advantage.fromJson(Map<String, dynamic> json) {
    return Advantage(id: json['id'], name: json['name']);
  }
}

class AdvantagesList extends StatefulWidget {
  @override
  _AdvantagesListState createState() => _AdvantagesListState();
}

class _AdvantagesListState extends State<AdvantagesList> {
  List<Advantage> allAdvantages = [];
  List<String> selectedAdvantages = [];
  List<String> alreadySelectedAdvantages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAllAdvantages();
    fetchAlreadySelectedAdvantages();
  }

  Future<void> fetchAllAdvantages() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.199.207/abaadDashboard/api/v1/estate/advantages'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          allAdvantages = data.map((item) => Advantage.fromJson(item)).toList();
        });
      } else {
        print('Failed to load advantages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching advantages: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAlreadySelectedAdvantages() async {
    try {
      final response =
      await http.get(Uri.parse('http://192.168.199.207/abaadDashboard/api/v1/estate/existing-advantages'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          alreadySelectedAdvantages = data.map<String>((item) => item['name']).toList();
        });
      } else {
        print('Failed to load already selected advantages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching already selected advantages: $e');
    }
  }

  bool _isAlreadySelected(String advantageName) {
    return alreadySelectedAdvantages.contains(advantageName);
  }

  bool _isAnyAlreadySelected(List<String> advantageNames) {

    return advantageNames.any((name) => alreadySelectedAdvantages.contains(name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advantages List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: allAdvantages.length,
        itemBuilder: (context, index) {
          final isSelected = selectedAdvantages.contains(allAdvantages[index].name);
          final isAlreadySelected = _isAnyAlreadySelected([allAdvantages[index].name]);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: isSelected || isAlreadySelected ? 8.0 : 2.0,
              shadowColor: Colors.blue.withOpacity(0.5),
              color: isAlreadySelected ? Colors.black : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ListTile(
                title: Text(allAdvantages[index].name),
                tileColor: isSelected ? Colors.blue.withOpacity(0.2) : null,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedAdvantages.remove(allAdvantages[index].name);
                    } else {
                      selectedAdvantages.add(allAdvantages[index].name);
                    }
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedAdvantages.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdvantagesUpdateScreen(selectedAdvantages: selectedAdvantages),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('No advantages selected'),
            ));
          }
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}

class AdvantagesUpdateScreen extends StatelessWidget {
  final List<String> selectedAdvantages;

  AdvantagesUpdateScreen({@required this.selectedAdvantages});

  @override
  Widget build(BuildContext context) {
    // Implement the UI for updating selected advantages
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Advantages'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected Advantages: $selectedAdvantages'),
            // Implement the rest of the UI as needed
          ],
        ),
      ),
    );
  }
}
