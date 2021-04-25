import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isdone;

  TodoWidget({this.text, @required this.isdone});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                right: 15.0
              ),
              child: Icon(Icons.check,color: isdone?Colors.white:Colors.transparent,size: 20.0,),
                height: 25.0,
                width: 25.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: isdone ? null: Border.all(
                    color: Colors.grey,
                    width: 1.5
                  ),
                  color: isdone ? Theme.of(context).primaryColor : Colors.transparent,),

                ),
            Flexible(
              child: Text(text ?? "{Unnamed Todo}",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: isdone?Colors.black87:Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
