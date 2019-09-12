
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_center/Adapters/adapter_authorization.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_settings.dart';
import 'package:furniture_center/global_state.dart';
import 'package:furniture_center/users/client/write_order.dart';
import 'package:provider/provider.dart';

class WorkspaceClient extends StatefulWidget
{
  @override
  _StateWorkspaceClient createState() => _StateWorkspaceClient();
}

class _StateWorkspaceClient extends State<WorkspaceClient>
{
  GlobalState _globalState = GlobalState();
  GlobalKey keyDrawer = GlobalKey();

  Widget _widget;
  String _chooseTable;
  String _chooseTitle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTables();
  }

  void choice(String choice)
  {
    switch(choice)
    {
      case PopupMenuSettingsAdmin.exit:
      {
        Provider.of<AdapterAuthorization>(context).auth = false;
        break;
      }

      case PopupMenuSettingsAdmin.main:
      {
        
        setState(() {
          _chooseTable = "Главная";
        });
      }
    }
  }

  List<String> _nameTables = 
  [
    'Сделать заказ',
  ];

  List<Widget> _tables = List<Widget>();

  void setTables()
  {
    _nameTables.forEach((name)
    {
      _tables.add(
        FlatButton
        (
          onPressed: ()
          { 
            setState(() {
              _chooseTable = name;
              Navigator.pop(keyDrawer.currentContext);
            });
          },
          child: Row
          (
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>
            [
              Text
              (
                name,
                style: TextStyle
                (
                  color: Colors.white,
                  fontSize: 25
                ),
              ),
              Padding
              (
                padding: EdgeInsets.only(left: 10),
                child: Icon
                (
                  Icons.accessible,
                  color: Colors.white,
                  size: 30,
                ),
              )
            ],
          )
        ), 
      );
    });
  }

  Widget _default(BuildContext context)
  {
    return Center
    (
      child: Text('Главная'),
    );
  }

  
  @override
  Widget build(BuildContext context)
  {
    switch(_chooseTable)
    {
      case "Сделать заказ":
      {
        _widget = WriteOrder();
        _chooseTitle = "Заказ";
        break;
      }

      default:
      {
        _widget = _default(context);
        _chooseTitle = _globalState.user.email;
        break;
      }
    }
    return MaterialApp
    (
      home: Scaffold
      (
        appBar: AppBar
        (
          title: Text(_chooseTitle),
          backgroundColor: Colors.blue,
          actions: <Widget>
          [
            PopupMenuButton
            (
              onSelected: choice,
              icon: Icon
              (
                Icons.settings,
                color: Colors.white,
              ), 
              itemBuilder: (BuildContext context)
              {
                return PopupMenuSettingsAdmin.choices.map((String choice)
                {
                  return PopupMenuItem<String>
                  (
                    value: choice,
                    child: Text(choice)
                  );
                }).toList();
              },
            )
          ],
        ),

        drawer: Drawer
        (
          key: keyDrawer,
          child: Container
          (
            color: Colors.blue,
            child: Column
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: _tables,
            ),
          ),
        ),

        body: _widget,

      ),
    );
  }
}