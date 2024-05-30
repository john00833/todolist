import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Task {
  final String title;
  TaskStatus status;

  Task({required this.title, this.status = TaskStatus.toDo});
}

enum TaskStatus { toDo, inProgress, done }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'TO DO LIST',
            style: TextStyle(color: Colors.blue[900]),
          ),
        ),
        body: TaskList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.refresh, color: Colors.white),
        ),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [
    Task(title: 'Ap2 Disciplina Mobile'),
    Task(title: 'APS Redes de Computadores'),
  ];
  final TextEditingController _taskController = TextEditingController();

  void addTask(String title) {
    if (title.isNotEmpty) {
      setState(() {
        tasks.add(Task(title: title));
      });
      _taskController.clear();
    }
  }

  void updateTaskStatus(Task task, TaskStatus newStatus) {
    setState(() {
      task.status = newStatus;
    });
  }

  List<Task> getTasksByStatus(TaskStatus status) {
    return tasks.where((task) => task.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Adicione uma nova tarefa',
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              SizedBox(
                height: 56, 
                child: ElevatedButton(
                  onPressed: () {
                    addTask(_taskController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  child: Text('NOVA', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              buildTaskColumn('A FAZER', TaskStatus.toDo),
              buildTaskColumn('EM ANDAMENTO', TaskStatus.inProgress),
              buildTaskColumn('FEITO', TaskStatus.done),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTaskColumn(String title, TaskStatus status) {
    var tasksByStatus = getTasksByStatus(status);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: tasksByStatus.length * 60.0,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tasksByStatus.length,
            itemBuilder: (context, index) {
              var task = tasksByStatus[index];
              return ListTile(
                title: Text(task.title),
                trailing: DropdownButton<TaskStatus>(
                  value: task.status,
                  onChanged: (newStatus) {
                    if (newStatus != null) {
                      updateTaskStatus(task, newStatus);
                    }
                  },
                  items: TaskStatus.values.map((TaskStatus status) {
                    return DropdownMenuItem<TaskStatus>(
                      value: status,
                      child: Text(status
                          .toString()
                          .split('.')
                          .last
                          .toUpperCase()),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
