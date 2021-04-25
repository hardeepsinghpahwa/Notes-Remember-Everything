import 'package:flutternotes/models/Todo.dart';
import 'package:flutternotes/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> getdatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        await db.execute(
            "CREATE TABLE todo(id INTEGER PRIMARY KEY, taskid INTEGER,title TEXT, isdone INTEGER)");

        return db;
      },
      version: 1,
    );
  }

  Future<int> inserttask(Task task) async {
    int _taskid = 0;
    Database _db = await getdatabase();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      _taskid = value;
    });
    return _taskid;
  }

  Future<void> inserttodo(Todo todo) async {
    Database _db = await getdatabase();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database db = await getdatabase();
    List<Map<String, dynamic>> map = await db.query('tasks');
    return List.generate(map.length, (index) {
      return Task(
          id: map[index]['id'],
          title: map[index]['title'],
          description: map[index]['description']);
    });
  }

  Future<List<Todo>> getTodos(int taskid) async {
    Database db = await getdatabase();
    List<Map<String, dynamic>> map =
        await db.rawQuery('SELECT * FROM todo WHERE taskid = $taskid');
    return List.generate(map.length, (index) {
      return Todo(
          id: map[index]['id'],
          title: map[index]['title'],
          isdone: map[index]['isdone'],
          taskid: map[index]['taskid']);
    });
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await getdatabase();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDesc(int id, String desc) async {
    Database _db = await getdatabase();
    await _db.rawUpdate("UPDATE tasks SET description = '$desc' WHERE id = '$id'");
  }

  Future<void> updateTodoDone(int id, int done) async {
    Database _db = await getdatabase();
    await _db.rawUpdate("UPDATE todo SET isdone = '$done' WHERE id = '$id'");
  }

  Future<void> deletetask(int id) async {
    Database _db = await getdatabase();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskid = '$id'");
  }
}
