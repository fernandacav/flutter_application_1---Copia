class Task {
  int? id;
  String title;
  bool done;

  Task(this.title, {this.id, this.done = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'done': done ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      map['title'] as String,
      id: map['id'] as int?,
      done: (map['done'] as int) == 1,
    );
  }
}
