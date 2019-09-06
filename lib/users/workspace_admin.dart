
import 'package:flutter/material.dart';
import 'package:furniture_center/Adapters/adapter_authorization.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_settings.dart';
import 'package:furniture_center/tables/table_furniture.dart';
import 'package:furniture_center/tables/table_materials.dart';
import 'package:furniture_center/tables/table_provider.dart';
import 'package:furniture_center/tables/table_purchases.dart';
import 'package:furniture_center/tables/table_users.dart';
import 'package:provider/provider.dart';

class WorkSpaceAdmin extends StatefulWidget
{
  @override
  _StateWorkSpaceAdmin createState() => _StateWorkSpaceAdmin();
}

class _StateWorkSpaceAdmin extends State<WorkSpaceAdmin>
{
  GlobalKey keyDrawer = GlobalKey();
  String _chooseTable = "";
  Widget _widget;

  String _tableTitle = "";

  List<String> _nameTables = 
  [
    'Пользователи',
    'Мебель',
    'Поставщики',
    'Материалы',
    'Закупки'
  ];

  List<Widget> _tables = List<Widget>();

  void choice(String choice)
  {
    switch(choice)
    {
      case PopupMenuSettingsAdmin.exit:
      {
        Provider.of<AdapterAuthorization>(context).auth = false;
      }
    }
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTables();
  }

  @override
  Widget build(BuildContext context)
  {
    switch(_chooseTable)
    {
      case "Пользователи":
      {
        _widget = TableUsers();
        _tableTitle = "Пользователи";
        break;
      }

      case "Мебель":
      {
        _widget = TableFurniture();
        _tableTitle = "Мебель";
        break;
      }

      case "Поставщики":
      {
        _widget = TableProviders();
        _tableTitle = "Поставщики";
        break;
      }

      case "Материалы":
      {
        _widget = TableMaterials();
        _tableTitle = "Материалы";
        break;
      }

      case "Закупки":
      {
        _widget = TablePurchases();
        _tableTitle = "Закупки";
        break;
      }

      default: _widget = Text('Выберите таблицу из списка');
    }
    return MaterialApp
    (
      home: Scaffold
      (
        appBar: AppBar
        (
          centerTitle: true,
          title: Text(_tableTitle),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _tables,
            ),
          )
        ),
        body: _widget,
      ),
    );
  }
}