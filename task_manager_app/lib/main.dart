import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: TaskListScreen()));
}

class Task {
  String name;
  bool isCompleted;
  String priority;

  Task({required this.name, this.isCompleted = false, required this.priority});
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> taskList = [];
  TextEditingController taskController = TextEditingController();
  String selectedPriority = 'Medium';

  // Add a task
  void addTask(String taskName, String priority) {
    setState(() {
      taskList.add(Task(name: taskName, priority: priority));
      sortTasksByPriority();  // Ensure sorting after adding a task
    });
  }

  // Toggle task completion
  void toggleCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  // Delete a task
  void deleteTask(Task task) {
    setState(() {
      taskList.remove(task);
    });
  }

  // Sort tasks based on priority
  void sortTasksByPriority() {
    taskList.sort((a, b) {
      if (a.priority == b.priority) return 0;
      if (a.priority == 'High') return -1;
      if (b.priority == 'High') return 1;
      if (a.priority == 'Medium') return -1;
      return 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(labelText: 'Enter task name'),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedPriority,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPriority = newValue!;
                    });
                  },
                  items: <String>['Low', 'Medium', 'High']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      addTask(taskController.text, selectedPriority);
                      taskController.clear();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  final task = taskList[index];
                  return ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? newValue) {
                        toggleCompletion(task);
                      },
                    ),
                    title: Text(
                      task.name,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text('Priority: ${task.priority}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteTask(task);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
