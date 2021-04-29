
import 'package:flutter/material.dart';
import 'package:flutter_sidenav/flutter_sidenav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SideBarScaffold(
       selectedColor: Colors.blueGrey,
        backgroundColor: Colors.grey[100],
        items: [
          SideNavItem(
            name: "Tab 1",
            page: ExamplePage1(),
            iconData: Icons.person,
          ),
          SideNavItem(
            name: "Tab 2",
            page: ExamplePage2(),
            iconData: Icons.info,
          ),
          SideNavItem(
            name: "Tab 3",
            page: ExamplePage3(),
            iconData: Icons.favorite,
          ),
        ],
      ),
    );
  }

}


class ExamplePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("ExamplePage1"),
      ),
      body: Center(
        child: Text("This is the content for page 1"),
      ),
    );
  }
}

class ExamplePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("ExamplePage2"),
      ),
      body: Center(
        child: Text("This is the content for page 2"),
      ),
    );
  }
}

class ExamplePage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("ExamplePage3"),
      ),
      body: Center(
        child: Text("This is the content for page 3"),
      ),
    );
  }
}


