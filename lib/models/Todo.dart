class Todo{
  final int id;
  final String title;
  final int isdone;
  final int taskid;

  Todo({this.id, this.title, this.isdone,this.taskid});

  Map<String,dynamic> toMap()
  {

    return {
      'id':id,
      'title':title,
      'isdone':isdone,
      'taskid':taskid
    };
  }

}