
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_center/Adapters/adapter_authorization.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_settings.dart';
import 'package:furniture_center/global_state.dart';
import 'package:furniture_center/tables/table_furniture.dart';
import 'package:furniture_center/tables/table_materials.dart';
import 'package:furniture_center/tables/table_orders.dart';
import 'package:furniture_center/tables/table_provider.dart';
import 'package:furniture_center/tables/table_purchases.dart';
import 'package:furniture_center/tables/table_stock.dart';
import 'package:furniture_center/tables/table_users.dart';
import 'package:furniture_center/tables/table_write_orders.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class WorkSpaceManager extends StatefulWidget
{
  _StateWorkSpaceManager createState() => _StateWorkSpaceManager();
}

class _StateWorkSpaceManager extends State<WorkSpaceManager>
{
  GlobalState _globalState = GlobalState();
  Widget _widget;
  String _chooseTable = "";
  String _chooseTitle;
  GlobalKey keyDrawer = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTables();
  }

  Widget _default(BuildContext context)
  {
    return Center
    (
      child: Text('Главная'),
    );
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
    'Посмотреть заказы',
    'Поставщики',
    'Мебель',
    'Пользователи',
    'Материалы',
    'Закупки',
    'Заказы',
    'Склад'
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
                  fontSize: 20
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
  Widget build(BuildContext context)
  {
    switch(_chooseTable)
    {
      case "Пользователи":
      {
        _widget = TableUsers();
        _chooseTitle = "Пользователи";
        break;
      }

      case "Мебель":
      {
        _widget = TableFurniture();
        _chooseTitle = "Мебель";
        break;
      }

      case "Поставщики":
      {
        _widget = TableProviders();
        _chooseTitle = "Поставщики";
        break;
      }

      case "Материалы":
      {
        _widget = TableMaterials();
        _chooseTitle = "Материалы";
        break;
      }

      case "Закупки":
      {
        _widget = TablePurchases();
        _chooseTitle = "Закупки";
        break;
      }

      case "Заказы":
      {
        _widget = TableOrder();
        _chooseTitle = "Заказы";
        break;
      }

      case "Посмотреть заказы":
      {
        _widget = TableWriteOrders();
        _chooseTitle = "Посмотреть заказы";
        break;
      }

      case "Склад":
      {
        _widget = TableStock();
        _chooseTitle = "Склад";
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
        )
      );
  }
}