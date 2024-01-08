// main.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Todo {
  int id;
  String title;
  bool completed;

  Todo({@required this.id, @required this.title, @required this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

class TodoService {
  static const apiUrl = 'http://your-laravel-api-endpoint.com/api/todos';

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Todo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${todo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'completed': todo.completed}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }
}

class ViewTodoScreen extends StatelessWidget {
  final Todo todo;

  ViewTodoScreen({@required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${todo.title}'),
            SizedBox(height: 8),
            Text('Completed: ${todo.completed}'),
          ],
        ),
      ),
    );
  }
}

class UpdateTodoScreen extends StatefulWidget {
  final Todo todo;

  UpdateTodoScreen({@required this.todo});

  @override
  _UpdateTodoScreenState createState() => _UpdateTodoScreenState();
}

class _UpdateTodoScreenState extends State<UpdateTodoScreen> {
   bool completed;

  @override
  void initState() {
    super.initState();
    completed = widget.todo.completed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${widget.todo.title}'),
            SizedBox(height: 8),
            Checkbox(
              value: completed,
              onChanged: (value) {
                setState(() {
                  completed = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Update the completed status in the backend
                // and update the UI accordingly
                await TodoService().updateTodo(
                  Todo(
                    id: widget.todo.id,
                    title: widget.todo.title,
                    completed: completed,
                  ),
                );

                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              child: Text('Update Todo'),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
   List<Todo> todos;
   TodoService todoService;

  @override
  void initState() {
    super.initState();
    todoService = TodoService();
    todos = [];
    fetchTodos();
  }

  void fetchTodos() async {
    List<Todo> fetchedTodos = await todoService.fetchTodos();
    setState(() {
      todos = fetchedTodos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            subtitle: Text('Completed: ${todos[index].completed}'),
            trailing: Checkbox(
              value: todos[index].completed,
              onChanged: (bool value) {
                // Update the completed status in the backend
                // and update the UI accordingly
                // You may use todoService.updateTodo here
                // to update the completed status in Laravel API
                setState(() {
                  todos[index].completed = value;
                });
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewTodoScreen(todo: todos[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: TodoScreen(),
));
