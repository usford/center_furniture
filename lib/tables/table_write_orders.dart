
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_center/Adapters/adapter_users.dart';
import 'package:furniture_center/Adapters/adapter_write_orders.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_change_cell.dart';
import 'package:provider/provider.dart';

class TableWriteOrders extends StatefulWidget
{
  @override
  _StateTableWriteOrders createState() => _StateTableWriteOrders();
}

class _StateTableWriteOrders extends State<TableWriteOrders>
{ 
  void visibleAddOrder()
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return DialogAddOrder(nameButton: 'Добавить',);
      }
    );
  }

  void changeCell(String choice, String id, BuildContext context, WriteOrder writeOrder)
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
            return DialogAddOrder(nameButton: "Редактировать");
          }
        );
        break;
      }

      case PopupMenuChangeCell.delete:
      {
        print('Удалить');
        Provider.of<AdapterWriteOrder>(context).remove(id);
        break;
      }
    }
  }
  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider<AdapterWriteOrder>
    (
      builder: (_) => AdapterWriteOrder(),
      child: Consumer<AdapterWriteOrder>
      (
        builder: (context, value, child)
        {
          return Scaffold
          (
            body: Center
            (
              child: ListView.builder(
                itemCount: value.writeOrders.length,
                itemBuilder: (BuildContext context, int index)
                {
                  WriteOrder writeOrder = WriteOrder();
                  writeOrder = value.writeOrders[index];

                  List<User> users = Provider.of<AdapterUser>(context).users.where((user) => user.documentID == value.writeOrders[index].clientID).toList();
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
                                  Text('ID клиента:', textAlign: TextAlign.center,),
                                  Text('${value.writeOrders[index].clientID}', textAlign: TextAlign.center,)
                                ]
                              ),

                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('Email:', textAlign: TextAlign.center,),
                                  Text('${users[0].email}', textAlign: TextAlign.center,)
                                ]
                              ),

                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('Пожелание:', textAlign: TextAlign.center,),
                                  Text('${value.writeOrders[index].text}', textAlign: TextAlign.center,)
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
                                      changeCell(choice, value.writeOrders[index].documentID, context, writeOrder);
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
                visibleAddOrder();
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

class DialogAddOrder extends StatefulWidget
{
  final String nameButton;
  final WriteOrder writeOrder;
  DialogAddOrder({this.writeOrder, this.nameButton});
  @override
  _StateDialogAddOrder createState() => _StateDialogAddOrder();
}

class _StateDialogAddOrder extends State<DialogAddOrder>
{
  TextEditingController controllerText = TextEditingController();

  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  void addOrder(BuildContext context)
  {
  }

  void changeOrder(BuildContext context)
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
            title: Text(widget.writeOrder != null ? 'Редактирование заказа' : 'Оформление заказа'),
            content: Container
            (
              height: MediaQuery.of(context).size.height/4,
              child: Column
              (
                children: <Widget>
                [
                  TextField
                  (
                    decoration: InputDecoration
                    (
                      hintText: 'Введите пожелания'
                    ),
                    controller: controllerText,
                  ),
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
                      addOrder(context);
                      break;
                    
                    case "Редактировать":
                      changeOrder(context);
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