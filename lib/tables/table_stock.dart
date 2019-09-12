
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_center/Adapters/adapter_stock.dart';
import 'package:furniture_center/Adapters/adapter_users.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_change_cell.dart';
import 'package:provider/provider.dart';

class TableUsers extends StatefulWidget
{
  @override
  _StateTableUsers createState() => _StateTableUsers();
}

class _StateTableUsers extends State<TableUsers>
{ 
  void visibleAddStock()
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return DialogAddStock(nameButton: 'Добавить',);
      }
    );
  }

  void changeCell(String choice, String id, BuildContext context, Stock stock)
  {
    switch(choice)
    {
      case PopupMenuChangeCell.edit:
      {
        print('Редактировать');
        showDialog(
          context: context,
          builder: (BuildContext context)
          {
            return DialogAddStock(nameButton: "Редактировать");
          }
        );
        break;
      }

      case PopupMenuChangeCell.delete:
      {
        print('Удалить');
        Provider.of<AdapterStock>(context).remove(id);
        break;
      }
    }
  }
  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider<AdapterStock>
    (
      builder: (_) => AdapterStock(),
      child: Consumer<AdapterStock>
      (
        builder: (context, value, child)
        {
          return Scaffold
          (
            body: Center
            (
              child: ListView.builder(
                itemCount: value.stock.length,
                itemBuilder: (BuildContext context, int index)
                {
                  Stock stock = Stock();
                  stock = value.stock[index];
                  return Card
                  (
                    child: Row
                    (
                      children: <Widget>
                      [
                        Flexible
                        (
                          fit: FlexFit.tight,
                          flex: 9,
                          child: Table
                          (
                            defaultColumnWidth: FractionColumnWidth(.10),
                            children: 
                            [
                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('ID материала:', textAlign: TextAlign.center,),
                                  Text('${value.stock[index].material.name}', textAlign: TextAlign.center,)
                                ]
                              ),
                            ],
                          ),
                        ),

                        Flexible
                        (
                          flex: 1,
                          fit: FlexFit.tight,
                          child: PopupMenuButton
                          (
                            icon: Icon
                            (
                              Icons.more_vert
                            ),
                            itemBuilder: (BuildContext context)
                            {
                              return PopupMenuChangeCell.choices.map((String choice)
                              {
                                return PopupMenuItem<String>
                                (
                                  value: choice,
                                  child: ListTile
                                  (
                                    title: Text(choice),
                                    onTap: ()
                                    {
                                      changeCell(choice, value.stock[index].documentID, context, stock);
                                      Navigator.pop(context);
                                    },
                                  )
                                );
                              }).toList();
                            },
                          )
                        )
                      ],
                    )
                  );
                },
              )
            ),
            floatingActionButton: FloatingActionButton
            (
              onPressed: ()
              {
                visibleAddStock();
              },
              child: Icon
              (
                Icons.add
              ),
            ),
          );
        },
      )
    );
  }
}

class DialogAddStock extends StatefulWidget
{
  final Stock stock;
  final String nameButton;
  DialogAddStock({this.nameButton = "Добавить", this.stock});
  @override
  _StateDialogAddStock createState() => _StateDialogAddStock();
}

class _StateDialogAddStock extends State<DialogAddStock>
{

  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }


  void addStock(BuildContext context)
  {
  }

  void changeStock(BuildContext context)
  {
  }
  
  @override
  Widget build(BuildContext context)
  {

    return ChangeNotifierProvider<AdapterUser>
    (
      builder: (_) => AdapterUser(),
      child: Consumer<AdapterUser>
      (
        builder: (context, value, child)
        {
          return AlertDialog
          (
            title: Text(widget.stock != null ? 'Редактирование пользовател' : 'Добавление пользователя'),
            content: Container
            (
              height: MediaQuery.of(context).size.height/4,
              child: Column
              (
                children: <Widget>
                [  
                ],
              ),
            ),
            actions: <Widget>
            [
              FlatButton
              (
                onPressed: ()
                {
                  switch (widget.nameButton)
                  {
                    case "Добавить":
                      addStock(context);
                      break;
                    
                    case "Редактировать":
                      changeStock(context);
                      break;
                  }
                  Navigator.pop(context);
                },
                child: Text(widget.nameButton),
              )
            ],
          );
        }
      )
    ); 
  }
}