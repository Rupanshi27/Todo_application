import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Set the status bar and navigation bar color to black
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(255, 11, 8, 8),
    systemNavigationBarColor: Color.fromARGB(255, 131, 14, 151),
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData(
        // Use a dark theme
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'To-Do App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // A list of tasks to display
  List<String> _tasks = [];

  // A controller for the text field
  TextEditingController _controller = TextEditingController();

  // A function to add a new task to the list
  void _addTask() {
    setState(() {
      // Get the text from the controller
      String task = _controller.text;
      // If the text is not empty, add it to the list
      if (task.isNotEmpty) {
        _tasks.add(task);
        // Clear the controller
        _controller.clear();
      }
    });
  }

  // A function to remove a task from the list
  void _removeTask(int index) {
    setState(() {
      // Remove the task at the given index
      _tasks.removeAt(index);
    });
  }

  // A function to mark a task as done or undone
  void _toggleTask(int index) {
    setState(() {
      // Get the task at the given index
      String task = _tasks[index];
      // If the task starts with '[x] ', remove it
      if (task.startsWith('[x] ')) {
        task = task.substring(4);
      } else {
        // Otherwise, add '[x] ' at the beginning
        task = '[x] ' + task;
      }
      // Update the task at the given index
      _tasks[index] = task;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Use the widget title as the app bar title
        title: Text(widget.title),
        // Add an action button to clear all tasks
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                // Clear the list of tasks
                _tasks.clear();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // A text field to enter a new task
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter a new task',
                ),
                // When the user presses enter, add the task
                onSubmitted: (value) => _addTask(),
              ),
            ),
            // A list view to display the tasks
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(_tasks[index]),
                    // When the user swipes the item, remove the task
                    onDismissed: (direction) => _removeTask(index),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(_tasks[index]),
                      leading:
                      Icon(_tasks[index].startsWith('[x] ') ? Icons.check_box : Icons.check_box_outline_blank),
                      onTap: () {
                        // When the user taps the item, toggle the task status
                        _toggleTask(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}