import 'package:flutter/material.dart';

class AddNewTask extends StatelessWidget {

  final String title,desc;


  AddNewTask({this.title,this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "Unnamed Task",
            style: TextStyle(
                color: Colors.black,
                fontSize: 22.0,
                fontWeight: FontWeight.bold
            ),
          ),Padding(
            padding: EdgeInsets.only(
                top: 10.0
            ),
            child: Text(
              desc ?? "No Description",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
    );

  }
}

