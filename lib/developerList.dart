import 'package:flutter/cupertino.dart';

class DevelopersList extends StatelessWidget
{

 Widget getTextWidgets(List<String> strings)
  {
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < strings.length; i++){
      list.add(new Text(strings[i]));
      print(strings[i]);
    }
    return new Column(children: list);
  }
  
  @override
  Widget build(BuildContext context) {
     return getTextWidgets(["liar","ok"]);
  }
}