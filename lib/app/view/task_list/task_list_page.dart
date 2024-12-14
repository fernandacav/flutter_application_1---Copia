import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/view/components/h1.dart';
import 'package:flutter_application_1/app/view/components/shape.dart';
import 'package:flutter_application_1/app/view/model/task.dart';

import '../../db/task_database.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final taskList = <Task> [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final tasks = await TaskDatabase.instance.readTasks();
    setState(() {
      taskList.addAll(tasks);
    });
  }

  @override
  void dispose() {
    TaskDatabase.instance.close();
    super.dispose();
  }

  void _addTask(Task task) async {
    final id = await TaskDatabase.instance.createTask(task);
      setState(() {
      task.id = id; // Atribui o ID gerado pelo banco
      taskList.add(task);
    });
  }

  void _deleteTask(Task task) async {
    if (task.id != null) {
      await TaskDatabase.instance.deleteTask(task.id!);
      setState(() {
        taskList.remove(task);
      });
    }
  }




  void _updateTask(Task task) async {
    if (task.id != null) {
      await TaskDatabase.instance.updateTask(task);
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            const _Header(),
            Expanded(child: _TaskList(
                taskList,
              onTaskDoneChange: (task) {
                  task.done = !task.done;
                  setState(() {});
              }, onTaskDelete: (Task task) {
                  _deleteTask(task);
                  },
            ),
            ),
          ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewTaskModal(context),
      child: const Icon(Icons.add, size: 50, color: Colors.white,),
      ),
          );
  }

  void _showNewTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _NewTaskModal(onTaskCreated: (Task task) {
        _addTask(task);
      setState(() {
        });
      }, onTaskUpdated: (Task task) {_updateTask(task);  },),
    );
  }
}

class _NewTaskModal extends StatelessWidget {
  _NewTaskModal({
    super.key,
    this.task,
    required this.onTaskCreated,
    required this.onTaskUpdated,
  });

  final Task? task;
  final _controller = TextEditingController();
  final void Function(Task task) onTaskCreated;
  final void Function(Task task) onTaskUpdated;

  @override
  Widget build(BuildContext context) {
    if (task != null) {
      _controller.text = task!.title;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 23),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          H1(task != null ? "Editar Tarefa" : "Nova Tarefa"),
          const SizedBox(height: 26),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              hintText: "Descrição da tarefa",
            ),
          ),
          const SizedBox(height: 26),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                if (task != null) {
                  task!.title = _controller.text;
                  onTaskUpdated(task!);
                } else {
                  final newTask = Task(_controller.text);
                  onTaskCreated(newTask);
                }
                Navigator.of(context).pop();
              }
            },
            child: Text(task != null ? "Atualizar" : "Salvar"),
          ),
        ],
      ),
    );
  }
}



class _TaskList extends StatelessWidget {
  const _TaskList(
      this.taskList, {
        super.key,
        required this.onTaskDoneChange,
        required this.onTaskDelete,
      });

  final List<Task> taskList;
  final void Function(Task task) onTaskDoneChange;
  final void Function(Task task) onTaskDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1("Tarefas"),
          Expanded(
            child: ListView.separated(
              itemBuilder: (_, index) => _TaskItem(
                taskList[index],
                onTap: () => onTaskDoneChange(taskList[index]),
                onDelete: () => onTaskDelete(taskList[index]),
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: taskList.length,
            ),
          ),
        ],
      ),
    );
  }
}


class _Header extends StatelessWidget {
  const _Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.primary,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Row(children: [Shape()]),
            Column(
                children: [
                  SizedBox(height: 100,),
                  Image.asset(
                    'assets/images/tasks-list-image.png',
                    width: 120,
                    height: 120,),
                  const SizedBox(height: 16,),
                  const H1("Complete suas tarefas", color: Colors.white),
                  const SizedBox(height: 24,)
                ]
            )
          ],
        )
    );
  }
}

class _TaskItem extends StatefulWidget {
  const _TaskItem(this.task, {Key? key, this.onTap, this.onDelete}) : super(key: key);

  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  State<_TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<_TaskItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    widget.task.done
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Text(widget.task.title),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: widget.onDelete,
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => _NewTaskModal(
                      task: widget.task,
                      onTaskCreated: (_) {},

                      onTaskUpdated: (updatedTask) {
                        setState(() {});
                      },
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}



