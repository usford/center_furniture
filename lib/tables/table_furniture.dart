
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_center/Adapters/adapter_furniture.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_change_cell.dart';
import 'package:provider/provider.dart';

class TableFurniture extends StatefulWidget
{
  @override
  _StateTableFurniture createState() => _StateTableFurniture();
}

class _StateTableFurniture extends State<TableFurniture>
{ 
  void visibleAddFurniture()
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return DialogAddFurniture();
      }
    );
  }

  void changeCell(String choice, String id, BuildContext context, Furniture furniture)
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
            return DialogAddFurniture(nameButton: 'Редактировать', furniture: furniture,);
          }
        );
        break;
      }

      case PopupMenuChangeCell.delete:
      {
        print('Удалить');
        Provider.of<AdapterFurniture>(context).remove(id);
        break;
      }
    }
  }
  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider<AdapterFurniture>
    (
      builder: (_) => AdapterFurniture(),
      child: Consumer<AdapterFurniture>
      (
        builder: (context, value, child)
        {
          return Scaffold
          (
            body: Center
            (
              child: ListView.builder(
                itemCount: value.furnitures.length,
                itemBuilder: (BuildContext context, int index)
                {
                  Furniture user = Furniture();
                  user = value.furnitures[index];
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
                                  Text('Название мебели:', textAlign: TextAlign.center,),
                                  Text('${value.furnitures[index].name}', textAlign: TextAlign.center,)
                                ]
                              ),

                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('Количество:', textAlign: TextAlign.center,),
                                  Text('${value.furnitures[index].amount}', textAlign: TextAlign.center,)
                                ]
                              ),

                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('Цена:', textAlign: TextAlign.center,),
                                  Text('${value.furnitures[index].price} руб.', textAlign: TextAlign.center,)
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
                                      changeCell(choice, value.furnitures[index].documentID, context, user);
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
                visibleAddFurniture();
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

class DialogAddFurniture extends StatefulWidget
{
  final String nameButton;
  final Furniture furniture;

  DialogAddFurniture({this.nameButton = "Добавить", this.furniture});
  @override
  _StateDialogAddFurniture createState() => _StateDialogAddFurniture();
}

class _StateDialogAddFurniture extends State<DialogAddFurniture>
{
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAmount = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.furniture != null)
    {
      controllerName.text = widget.furniture.name;
      controllerAmount.text = widget.furniture.amount.toString();
      controllerPrice.text = widget.furniture.price.toString();
    }
  }

  void addFurniture(BuildContext context)
  {
    Furniture furniture = Furniture();

    furniture.name = controllerName.text;
    furniture.amount = int.parse(controllerAmount.text);
    furniture.price = int.parse(controllerPrice.text);

    Provider.of<AdapterFurniture>(context).add(furniture);
  }

  void changeFurniture(BuildContext context)
  {
    Furniture furniture = Furniture();

    furniture.documentID = widget.furniture.documentID;
    furniture.name = controllerName.text;
    furniture.amount = int.parse(controllerAmount.text);
    furniture.price = int.parse(controllerPrice.text);

    Provider.of<AdapterFurniture>(context).change(furniture);
  }
  
  @override
  Widget build(BuildContext context)
  {

    return ChangeNotifierProvider<AdapterFurniture>
    (
      builder: (_) => AdapterFurniture(),
      child: Consumer<AdapterFurniture>
      (
        builder: (context, value, child)
        {
          return AlertDialog
          (
            title: Text((widget.furniture != null ? 'Редактирование мебели' : 'Добавление мебели')),
            content: Container
            (
              height: MediaQuery.of(context).size.height/5,
              child: Column
              (
                children: <Widget>
                [ 
                  TextField
                  (
                    decoration: InputDecoration
                    (
                      hintText: 'Введите название'
                    ),
                    controller: controllerName,
                  ),

                  TextField
                  (
                    decoration: InputDecoration
                    (
                      hintText: 'Введите количество'
                    ),
                    controller: controllerAmount,
                  ),

                  TextField
                  (
                    decoration: InputDecoration
                    (
                      hintText: 'Введите цену'
                    ),
                    controller: controllerPrice,
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
                      addFurniture(context);
                      break;
                    
                    case "Редактировать":
                      changeFurniture(context);
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