import 'package:flutter/material.dart';
import 'package:flutternotes/widgets.dart';
import 'package:sqflite/sqflite.dart';

import 'database/database_helper.dart';
import 'models/Todo.dart';
import 'models/task.dart';

class NewTask extends StatefulWidget {
  final Task task;

  NewTask({@required this.task});

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  String _title = "";
  String _desc = "";
  DatabaseHelper db = DatabaseHelper();
  int _taskid = 0;

  FocusNode _titlefocus;
  FocusNode _descfocus;
  FocusNode _todofoucus;

  bool _visible = false;

  @override
  void initState() {
    if (widget.task != null) {
      _title = widget.task.title;
      _taskid = widget.task.id;
      _desc = widget.task.description;

      _visible = true;
    }

    _titlefocus = FocusNode();
    _descfocus = FocusNode();
    _todofoucus = FocusNode();
  }

  @override
  void dispose() {
    _titlefocus.dispose();
    _descfocus.dispose();
    _todofoucus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 30.0,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: TextField(
                              focusNode: _titlefocus,
                              controller: TextEditingController()
                                ..text = _title,
                              onSubmitted: (value) async {
                                if (value != "") {
                                  print(value);
                                  if (_taskid == 0) {
                                    DatabaseHelper db = DatabaseHelper();

                                    Task newtask = Task(
                                      title: value,
                                    );

                                    _taskid = await db.inserttask(newtask);

                                    setState(() {
                                      _visible = true;
                                      _title = value;
                                    });

                                    print('New Task Created');
                                  } else {
                                    db.updateTaskTitle(_taskid, value);
                                  }

                                  _descfocus.requestFocus();
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter Task Title',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _visible,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: TextField(
                          controller: TextEditingController()..text = _desc,
                          focusNode: _descfocus,
                          style: TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                              hintText: "Enter Description",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0)),
                          onSubmitted: (value) async {
                            if (_taskid != 0) {
                              await db.updateTaskDesc(_taskid, value);
                              _desc = value;
                            }
                            _todofoucus.requestFocus();
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _visible,
                      child: FutureBuilder(
                        initialData: [],
                        future: db.getTodos(_taskid),
                        builder: (context, snapshot) {
                          print(snapshot.data.length);
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (snapshot.data[index].isdone == 0) {
                                        await db.updateTodoDone(
                                            snapshot.data[index].id, 1);
                                      } else {
                                        await db.updateTodoDone(
                                            snapshot.data[index].id, 0);
                                      }
                                      setState(() {});
                                    },
                                    child: TodoWidget(
                                      text: snapshot.data[index].title,
                                      isdone: snapshot.data[index].isdone == 0
                                          ? false
                                          : true,
                                    ),
                                  );
                                }),
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: _visible,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Row(
                          children: [
                            Container(
                              child: Icon(
                                Icons.check,
                                color: Colors.transparent,
                                size: 20.0,
                              ),
                              height: 25.0,
                              width: 25.0,
                              margin: EdgeInsets.only(right: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border:
                                    Border.all(color: Colors.grey, width: 1.5),
                                color: Colors.transparent,
                              ),
                            ),
                            Expanded(
                                child: TextField(
                              controller: TextEditingController()..text = "",
                              focusNode: _todofoucus,
                              onSubmitted: (value) async {
                                if (value != null) {
                                  if (_taskid != 0) {
                                    Todo newtodo = Todo(
                                        title: value,
                                        isdone: 0,
                                        taskid: _taskid);

                                    await db.inserttodo(newtodo);
                                    setState(() {});
                                    _todofoucus.requestFocus();
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: "Enter Todo",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: _visible,
                child: Positioned(
                  right: 24.0,
                  bottom: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskid != 0) {
                        await db.deletetask(_taskid);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.redAccent),
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 25.0,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
