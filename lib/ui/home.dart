import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myusers_cupertino_flutter/services/user.service.dart';
import 'package:myusers_cupertino_flutter/models/user.dart';
import 'package:myusers_cupertino_flutter/helpers.dart';
import 'create.dart';
import 'detail.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  static const String routeName = '/Home';

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ScrollController scr = ScrollController();
  List<User> ls = <User>[];
  int page = 1;
  bool isLoading = false;
  final GlobalKey refreshIndicatorKey = GlobalKey();
  final GlobalKey scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    load();
    scr.addListener(() {
      if (scr.position.pixels == scr.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() async {
    try {
      setState(() {
        isLoading = true;
      });
      var o = await getUsers();
      setState(() {
        page = 1;
        ls = o.userList;
        isLoading = false;
      });
    }

    catch (error) {
      setState(() {
       isLoading = false;
       handleError(context, error, load);
      });
    }
  }

  void loadMore() async {
    int p = page + 1;
    try {
      var o = await getUsers(page = p);
      if (o.userList.length < 1) {
        return;
      }

      setState(() {
        page = p;
        ls.addAll(o.userList);
      });
    }

    catch (error) {
      handleError(context, error, loadMore);
    }
  }

  Future<void> refreshData() async {
    try {
      var o = await getUsers();
      ls.clear();
      setState(() {
        page = 1;
        ls = o.userList;
      });
    }

    catch (error) {
      handleError(context, error, () async {
        await refreshData();
      });
    }
  }

  Future<void> onCreateUser() async {
    final b = await Navigator.pushNamed(context, Create.routeName) ?? false;
    if (b) {
      Fluttertoast.showToast(
        msg: 'User successfully created!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.activeGreen,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }

  Widget buildRow(User o, int i) {
    final row = SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(
        left: 16,
        top: 8,
        bottom: 8,
        right: 8,
      ),
      child: CupertinoButton(
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                o.avatar,
                fit: BoxFit.cover,
                width: 76,
                height: 76,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      o.email,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: CupertinoColors.black
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8)
                    ),
                    Text(
                      '${o.firstName} ${o.lastName}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onPressed: () async {
          final b = await Navigator.pushNamed(context, Detail.routeName, arguments: o.id) ?? false;
          if (b) {
            Fluttertoast.showToast(
              msg: 'User successfully deleted!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: CupertinoColors.activeGreen,
              textColor: Colors.white,
              fontSize: 16.0
            );
            load();
          }
        },
      ),
    );

    if (i == ls.length - 1) {
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(
            left: 120,
            right: 16,
          ),
          child: Container(
            color: CupertinoColors.opaqueSeparator,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget buildList() {
    return SliverSafeArea(
      top: false,
      minimum: const EdgeInsets.only(top: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            User o = ls[i];
            if (i < ls.length) {
              return buildRow(o, i);
            }

            return null;
          },
          childCount: ls.length,
        ),
      ),
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return Center(child: CupertinoActivityIndicator());
    }
    
    return CustomScrollView(
      semanticChildCount: ls.length,
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text(widget.title),
          trailing: CupertinoButton(
            child: Icon(CupertinoIcons.add),
            onPressed: () async {
              await onCreateUser();
            },
          ),
        ),
        CupertinoSliverRefreshControl(
          key: refreshIndicatorKey,
          onRefresh: refreshData,
        ),
        buildList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      key: scaffoldKey,
      child: buildContent(),
    );
  }
}