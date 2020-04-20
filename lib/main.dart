import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myusers_cupertino_flutter/ui/home.dart';
import 'package:myusers_cupertino_flutter/ui/create.dart';
import 'package:myusers_cupertino_flutter/ui/detail.dart';
import 'package:myusers_cupertino_flutter/ui/edit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      Home.routeName: (BuildContext context) => Home(title: 'Users'),
      Create.routeName: (BuildContext context) => Create(title: 'Create'),
      Detail.routeName: (BuildContext context) => Detail(title: 'Detail'),
      Edit.routeName: (BuildContext context) => Edit(title: 'Edit')
    };

    return CupertinoApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: routes
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<bool> willPop() {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(''),
          content: Text('Are you sure you want to close application?'),
          actions: <Widget>[
            CupertinoButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            CupertinoButton(
              child: Text('YES'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      }
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return WillPopScope(
      onWillPop: willPop,
      child: Home(title: 'Users'),
    );
  }
}
