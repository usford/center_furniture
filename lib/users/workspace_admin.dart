
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furniture_center/Adapters/adapter_authorization.dart';
import 'package:furniture_center/Adapters/adapter_furniture.dart';
import 'package:furniture_center/Adapters/adapter_image.dart';
import 'package:furniture_center/Adapters/adapter_material.dart';
import 'package:furniture_center/Adapters/adapter_provider.dart';
import 'package:furniture_center/Adapters/adapter_purchase.dart';
import 'package:furniture_center/Adapters/adapter_users.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_settings.dart';
import 'package:furniture_center/tables/table_furniture.dart';
import 'package:furniture_center/tables/table_materials.dart';
import 'package:furniture_center/tables/table_provider.dart';
import 'package:furniture_center/tables/table_purchases.dart';
import 'package:furniture_center/tables/table_users.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class WorkSpaceAdmin extends StatefulWidget
{
  @override
  _StateWorkSpaceAdmin createState() => _StateWorkSpaceAdmin();
}

class _StateWorkSpaceAdmin extends State<WorkSpaceAdmin>
{
  GlobalKey keyDrawer = GlobalKey();
  String _chooseTable = "";

  var stateImage;
  
  Widget _widget;

  String _tableTitle = "";

  void report(BuildContext context) async
  {
    String body = "#;Provider;Material;Amount;Date;Price;Sum \n";
    var purchases = Provider.of<AdapterPurchase>(context).purchases;
    int total = 0;
    for (int i = 0; i < purchases.length; i++)
    {
      body += "${i + 1};${purchases[i].provider.name};${purchases[i].material.name};${purchases[i].amount};${purchases[i].date};${purchases[i].price};${purchases[i].amount * purchases[i].price} \n";
      total += purchases[i].amount * purchases[i].price;
    }


    body += ";;;;;Total;$total \n";
    body += ";;;;;; \n ;;;;;; \n";

    body += "Only ${purchases.length} providers with costs in $total \n";

    body += ";;;;;; \n ;;;;;; \n ;;;;;; \n";
    body += "Supervisor _____ ;;;Accountant _____";

    print(body);

    // String body = "#;Поставщики;Материал;Количество;Дата;Цена;Сумма \n" +
    // "1;postavshik 2;shurup;2;10.09.2019;2000;4000 \n" +
    // "2;postavshik 1;shurup;1234;09.09.2019;3292;4062328 \n" +
    // ";;;;;Итого;4066328 \n" +
    // ";;;;;;; \n" +
    // ";;;;;; \n" +
    // "Всего 2 поставщиков с затратами в 4066328 рублей \n" +
    // "Руководитель_____ ;;;;Buhgalter_____;;;";

    var _path = await FilePicker.getFile(type: FileType.ANY);
    _path.writeAsString(body);
  }


  void selectedImage(BuildContext context)
  {
    BuildContext _context = context;
    showDialog(
      context: _context,
      builder: (BuildContext _context)
      {
        return ChangeNotifierProvider<AdapterImage>
        (
          builder: (_) => AdapterImage(),
          child: Consumer<AdapterImage>
          (
            builder: (context, value, child)
            {
              List<Widget> widgets = List<Widget>();
              value.images.forEach((image)
              {
                widgets.add(
                  FlatButton
                  (
                    onPressed: ()
                    {
                      setState(() {
                        stateImage = File(image.path);
                      });
                      Navigator.pop(context);
                    },
                    child: Image.file(File(image.path)),
                  )
                );
              });
              return AlertDialog
              (
                title: Text('Выберите изображение'),
                content: Container
                (
                  width: 300,
                  height: 100,
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: widgets,
                  ),
                ),
              );
            },
          )
        );
      }
    );
  }

  


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

  
  void loadImage() async
  {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image.path);

    Provider.of<AdapterImage>(context).add(image.path);
  }

  void importExcel(BuildContext context) async
  {
    BuildContext _context = context;
    showDialog(
      context: _context,
      builder: (_context)
      {
        return DialogImportExcel(context);
      }
    );
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

  Widget _default(BuildContext context)
  {
    return Container
    (
      decoration: BoxDecoration
      (
        image: DecorationImage
        (
          fit: BoxFit.cover,
          image: (stateImage != null ) ? FileImage(stateImage) : NetworkImage('https://i.pinimg.com/736x/2d/dc/25/2ddc25914e2ae0db5311ffa41781dda1.jpg')
        )
      ),
      child: Center
      (
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [

            FlatButton
            (
              color: Colors.blue,
              onPressed: () => importExcel(context),
              child: Text
              (
                'Импорт',
                style: TextStyle
                (
                  color: Colors.white
                ),
              )
            ),

            FlatButton
            (
              color: Colors.blue,
              onPressed: () => loadImage(),
              child: Text
              (
                'Загрузить изображение',
                style: TextStyle
                (
                  color: Colors.white
                ),
              )
            ),

            FlatButton
            (
              color: Colors.blue,
              onPressed: () => selectedImage(context),
              child: Text
              (
                'Выбрать изображение',
                style: TextStyle
                (
                  color: Colors.white
                ),
              )
            ),

            FlatButton
            (
              color: Colors.blue,
              onPressed: () => report(context),
              child: Text
              (
                'Отчёт',
                style: TextStyle
                (
                  color: Colors.white
                ),
              )
            ),
          ],
        ),
      ),
    );
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

      default: _widget = _default(context);
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

class DialogImportExcel extends StatefulWidget
{ 
  final BuildContext myContext;
  DialogImportExcel(this.myContext);
  @override
  _StateDialogImportExcel createState() => _StateDialogImportExcel();
}

class _StateDialogImportExcel extends State<DialogImportExcel>
{
  var _selectTable = "";
  String _chooseTableExcel = "";

  List<Widget> _buttonsExcel = List<Widget>();

  List<String> _nameTables = 
  [
    'Пользователи',
    'Мебель',
    'Поставщики',
    'Материалы',
    'Закупки'
  ];

  String myData;


  void setButtonExcel()
  {
    _buttonsExcel = List<Widget>();
    _nameTables.forEach((table)
    {
      _buttonsExcel.add(
        FlatButton
        (
          onPressed: ()
          {
            setState(() {
              _chooseTableExcel = table;
            });
          },
          child: Text
          (
            table
          ),
          color: (_chooseTableExcel == table) ? Colors.blue : Colors.white,
        )
      );
    });
  }

  void openFile() async
  {
    var _path = await FilePicker.getFile(type: FileType.ANY);
    print(_path);
    String content = await _path.readAsString();
    print(content);
    myData = content;
  }

  Widget build(BuildContext context)
  {
    _selectTable = "";
    setButtonExcel();
    return AlertDialog
    (
      title: Text('Выберите таблицу для импорта'),
      content: Column
      (children: _buttonsExcel,),
      actions: <Widget>
      [
        FlatButton
        (
          onPressed: () => openFile(),
          child: Text('Загрузить файл'),
        ),

        FlatButton
        (
          onPressed: () async
          {

            List<List<dynamic>> csvTable = CsvToListConverter().convert(myData.toString().replaceAll(';', ','));
            var count = 0;
            var mainField;
            
            switch (_chooseTableExcel)
            {
              case "Пользователи":
              {
                csvTable.forEach((table)
                {
                  List data = List();
                  User user = User();

                  if (count == 0)
                  {
                    mainField = table;
                  }
                  if (count != 0)
                  {
                    for (int i = 0; i < table.length; i++)
                    {
                      //print('${mainField[i]}-${table[i]}');
                      data.add('${table[i]}');
                    }
                    user.documentID = data[0];
                    user.email = data[1];
                    user.password = data[2];
                    user.type = data[3];   
                    Provider.of<AdapterUser>(widget.myContext).add(user);
                  }
                  count++;
                });
                break;
              }

              case "Материалы":
              {
                csvTable.forEach((table)
                {
                  List data = List();
                  MyMaterial myMaterial = MyMaterial();

                  if (count == 0)
                  {
                    mainField = table;
                  }
                  if (count != 0)
                  {
                    for (int i = 0; i < table.length; i++)
                    {
                      //print('${mainField[i]}-${table[i]}');
                      data.add('${table[i]}');
                    }
                    myMaterial.documentID = data[0];
                    myMaterial.name = data[1];
                    myMaterial.fabric = data[2]; 
                    Provider.of<AdapterMaterial>(widget.myContext).add(myMaterial);
                  }
                  count++;
                });
                break;
              }

              case "Мебель":
              {
                csvTable.forEach((table)
                {
                  List data = List();
                  Furniture furniture = Furniture();

                  if (count == 0)
                  {
                    mainField = table;
                  }
                  if (count != 0)
                  {
                    for (int i = 0; i < table.length; i++)
                    {
                      //print('${mainField[i]}-${table[i]}');
                      data.add('${table[i]}');
                    }
                    furniture.documentID = data[0];
                    furniture.name = data[1];
                    furniture.amount = data[2]; 
                    furniture.price = data[3];
                    Provider.of<AdapterFurniture>(widget.myContext).add(furniture);
                  }
                  count++;
                });
                break;
              }

              case "Поставщики":
              {
                csvTable.forEach((table)
                {
                  List data = List();
                  MyProvider provider = MyProvider();

                  if (count == 0)
                  {
                    mainField = table;
                  }
                  if (count != 0)
                  {
                    for (int i = 0; i < table.length; i++)
                    {
                      //print('${mainField[i]}-${table[i]}');
                      data.add('${table[i]}');
                    }
                    provider.documentID = data[0];
                    provider.name = data[1];
                    provider.phone = data[2]; 
                    Provider.of<AdapterProvider>(widget.myContext).add(provider);
                  }
                  count++;
                });
                break;
              }

              case "Поставщики":
              {
                csvTable.forEach((table)
                {
                  List data = List();
                  Purchase purchase = Purchase();

                  if (count == 0)
                  {
                    mainField = table;
                  }
                  if (count != 0)
                  {
                    for (int i = 0; i < table.length; i++)
                    {
                      //print('${mainField[i]}-${table[i]}');
                      data.add('${table[i]}');
                    }
                    purchase.documentID = data[0];
                    purchase.material = data[1];
                    purchase.provider = data[2]; 
                    purchase.date = data[3]; 
                    purchase.amount = data[4]; 
                    purchase.price = data[5]; 
                    Provider.of<AdapterPurchase>(widget.myContext).add(purchase);
                  }
                  count++;
                });
                break;
              }

              default: Navigator.pop(context);
            }
            Navigator.pop(context);
            //Navigator.pop(context);
          },
          child: Text('Импортировать'),
        )
      ],
    );
  }
}
