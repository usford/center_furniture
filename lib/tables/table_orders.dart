
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_center/Adapters/adapter_furniture.dart';
import 'package:furniture_center/Adapters/adapter_material.dart';
import 'package:furniture_center/Adapters/adapter_orders.dart';
import 'package:furniture_center/Adapters/adapter_provider.dart';
import 'package:furniture_center/Adapters/adapter_purchase.dart';
import 'package:furniture_center/Adapters/adapter_users.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_change_cell.dart';
import 'package:provider/provider.dart';

class TableOrder extends StatefulWidget
{
  @override
  _StateTableOrders createState() => _StateTableOrders();
}

class _StateTableOrders extends State<TableOrder>
{ 
  List<User> _users;
  List<Furniture> _furnitures;
  void visibleAddPurchase()
  {
    showDialog(
      context: context,
      builder: (context)
      {
        return DialogAddOrder(nameButton: 'Добавить', users: _users, furnitures: _furnitures,);
      }
    );
  }

  void changeCell(String choice, String id, BuildContext context, Order order)
  {
    switch(choice)
    {
      case PopupMenuChangeCell.edit:
      {
        //print('Редактировать');
        showDialog(
          context: context,
          builder: (BuildContext context)
          {
            return DialogAddOrder(nameButton: 'Редактировать', furnitures: _furnitures, users: _users, order: order,);
          }
        );
        break;
      }

      case PopupMenuChangeCell.delete:
      {
        //print('Удалить');
        Provider.of<AdapterOrders>(context).remove(id);
        break;
      }
    }
  }

  void getUser(BuildContext context)
  {
    _users = List<User>();
    Provider.of<AdapterUser>(context).users.forEach((user)
    {
      //print(provider.documentID);
      _users.add(
        User
        (
          documentID: user.documentID,
          email: user.email,
          password: user.password
        )
      );
    });
  }

  void getFurniture(BuildContext context)
  {
    _furnitures = List<Furniture>();
    Provider.of<AdapterFurniture>(context).furnitures.forEach((furniture)
    {
      //print(provider.documentID);
      _furnitures.add(
        Furniture
        (
          documentID: furniture.documentID,
          name: furniture.name,
          amount: furniture.amount,
          price: furniture.price
        )
      );
    });
  }

  @override
  Widget build(BuildContext context)
  {
    getUser(context);
    getFurniture(context);
    print('обновилось');
    return Consumer<AdapterOrders>
    (
      builder: (context, value, child)
      {
        return Scaffold
        (
          body: Center
          (
            child: ListView.builder(
              itemCount: value.orders.length,
              itemBuilder: (BuildContext context, int index)
              {
                Order order = Order();
                order = value.orders[index];
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
                                Text('Клиент:', textAlign: TextAlign.center,),
                                Text('${value.orders[index].user.email}', textAlign: TextAlign.center,)
                              ]
                            ),

                            TableRow
                            (
                              children: <Widget>
                              [
                                Text('Мебель:', textAlign: TextAlign.center,),
                                Text('${value.orders[index].furniture.name}', textAlign: TextAlign.center,)
                              ]
                            ),

                            TableRow
                            (
                              children: <Widget>
                              [
                                Text('Стоимость заказа:', textAlign: TextAlign.center,),
                                Text('${value.orders[index].price} руб.', textAlign: TextAlign.center,)
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
                                    changeCell(choice, value.orders[index].documentID, context, order);
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
              visibleAddPurchase();
            },
            child: Icon
            (
              Icons.add
            ),
          ),
        );
      },
    );
  }
}

class DialogAddOrder extends StatefulWidget
{
  Order order;
  String nameButton;
  List<User> users;
  List<Furniture> furnitures;
  DialogAddOrder({this.order, this.nameButton, this.users, this.furnitures});
  @override
  _StateDialogAddOrder createState() => _StateDialogAddOrder();
}

class _StateDialogAddOrder extends State<DialogAddOrder>
{
  String _currentClient;

  List<User> _users;

  List<DropdownMenuItem<String>> _dropDownMenuClients;

  String _currentFurniture;

  List<Furniture> _furnitures;

  List<DropdownMenuItem<String>> _dropDownMenuFurnitures;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _users = List<User>();
    _users = widget.users;
    _dropDownMenuClients = getDropDownMenuClients();
    _currentClient = _dropDownMenuClients[0].value;

    _furnitures = List<Furniture>();
    _furnitures = widget.furnitures;
    _dropDownMenuFurnitures = getDropDownMenuFurnitures();
    _currentFurniture = _dropDownMenuFurnitures[0].value;

    if (widget.order != null)
    {
      _currentClient = widget.order.user.documentID;
      _currentFurniture = widget.order.furniture.documentID;
    }
  }
  void addOrder(BuildContext context) async
  {
    Order order = Order();
    User user = User();
    Furniture furniture = Furniture();

    user.documentID = _currentClient;
    furniture.documentID = _currentFurniture;

    int price;

    await Firestore.instance.collection('furnitures').getDocuments().then((body)
    {
      body.documents.forEach((doc)
      {
        if (doc.documentID == _currentFurniture)
        {
          furniture.amount = doc.data['amount'];
          furniture.price = doc.data['price'];

          price =  furniture.price * furniture.amount;
        }
      });
    });

    order.user = user;
    order.furniture = furniture;
    order.price = price;

    Provider.of<AdapterOrders>(context).add(order);
  }

  void changeOrder(BuildContext context)
  {
  }

  List<DropdownMenuItem<String>> getDropDownMenuClients()
  {
    List<DropdownMenuItem<String>> items = new List();
    for (User user in _users) 
    {
      items.add(new DropdownMenuItem
      (
          value: user.documentID,
          child: new Text(user.email)
      ));
    }
    return items;
  }

  void changedDropDownItemClient(String selectedClient)
  {
    setState(() {
      _currentClient = selectedClient; 
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuFurnitures()
  {
    List<DropdownMenuItem<String>> items = new List();
    for (Furniture furniture in _furnitures) 
    {
      items.add(new DropdownMenuItem
      (
          value: furniture.documentID,
          child: new Text(furniture.name)
      ));
    }
    return items;
  }

  void changedDropDownItemFurniture(String selectedFurniture)
  {
    setState(() {
      _currentFurniture = selectedFurniture; 
    });
  }
  
  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider<AdapterOrders>
    (
      builder: (_) => AdapterOrders(),
      child: Consumer<AdapterOrders>
      (
        builder: (context, value, child)
        {
          return AlertDialog
          (
            title: Text(widget.order != null ? 'Редактирование заказа' : 'Оформление заказа'),
            content: Container
            (
              height: MediaQuery.of(context).size.height/4,
              child: Column
              (
                children: <Widget>
                [
                  DropdownButton
                  (
                    value: _currentClient,
                    items: _dropDownMenuClients,
                    onChanged: changedDropDownItemClient,
                  ),

                  DropdownButton
                  (
                    value: _currentFurniture,
                    items: _dropDownMenuFurnitures,
                    onChanged: changedDropDownItemFurniture,
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