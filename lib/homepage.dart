import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'addnewtask.dart';
import 'database/database_helper.dart';
import 'newtaskpage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Color(0xFFf8f8f8),
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                    ),
                    child: Text(
                      "My Memory",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                    ),
                    child: Text(
                      "TODO App",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _databaseHelper.getTasks(),
                      builder: (context, snapshot) {
                        return ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> NewTask(task: snapshot.data[index],))).then((value) {
                                    setState(() {

                                    });
                                  });
                                },
                                child: AddNewTask(
                                  title: snapshot.data[index].title,
                                  desc: snapshot.data[index].description,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                right: 0.0,
                bottom: 24.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                            MaterialPageRoute(builder: (context) => NewTask(task: null,)))
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                            colors: [Colors.blue, Colors.lightBlue],
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, 1.0))),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
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
