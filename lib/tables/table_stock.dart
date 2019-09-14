
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_center/Adapters/adapter_material.dart';
import 'package:furniture_center/Adapters/adapter_stock.dart';
import 'package:furniture_center/Adapters/adapter_users.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_change_cell.dart';
import 'package:provider/provider.dart';

class TableStock extends StatefulWidget
{
  @override
  _StateTableStock createState() => _StateTableStock();
}

class _StateTableStock extends State<TableStock>
{ 
  List<MyMaterial> _materials;
  void visibleAddStock()
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return DialogAddStock(nameButton: 'Добавить', materials: _materials,);
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
            return DialogAddStock(nameButton: "Редактировать", stock: stock, materials: _materials,);
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

  void getMaterial(BuildContext context)
  {
    _materials = List<MyMaterial>();
    Provider.of<AdapterMaterial>(context).materials.forEach((material)
    {
      //print(provider.documentID);
      _materials.add(
        MyMaterial
        (
          documentID: material.documentID,
          name: material.name,
          fabric: material.fabric
        )
      );
    });
  }
  @override
  Widget build(BuildContext context)
  {
    getMaterial(context);
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
                                  Text('Материал:', textAlign: TextAlign.center,),
                                  Text('${value.stock[index].material.name}', textAlign: TextAlign.center,)
                                ]
                              ),

                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('Количество:', textAlign: TextAlign.center,),
                                  Text('${value.stock[index].amount}', textAlign: TextAlign.center,)
                                ]
                              ),

                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('Цена за штуку:', textAlign: TextAlign.center,),
                                  Text('${value.stock[index].price} р.', textAlign: TextAlign.center,)
                                ]
                              ),

                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('Сумма:', textAlign: TextAlign.center,),
                                  Text('${value.stock[index].sum} р.', textAlign: TextAlign.center,)
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
  final List<MyMaterial> materials;
  DialogAddStock({this.nameButton = "Добавить", this.stock, this.materials});
  @override
  _StateDialogAddStock createState() => _StateDialogAddStock();
}

class _StateDialogAddStock extends State<DialogAddStock>
{

  TextEditingController controllerAmount = TextEditingController();
  TextEditingController controllerPrice= TextEditingController();

  String _currentMaterial;
  List<MyMaterial> _materials;
  List<DropdownMenuItem<String>> _dropDownMenuMaterials;
  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _materials = List<MyMaterial>();
    _materials = widget.materials;
    _dropDownMenuMaterials = getDropDownMenuMaterials();
    _currentMaterial = _dropDownMenuMaterials[0].value;

    if (widget.stock != null)
    {
      _currentMaterial = widget.stock.material.documentID;
      controllerAmount.text = widget.stock.amount.toString();
      controllerPrice.text = widget.stock.price.toString();
    }
  }

  List<DropdownMenuItem<String>> getDropDownMenuMaterials()
  {
    List<DropdownMenuItem<String>> items = new List();
    for (MyMaterial material in _materials) 
    {
      items.add(new DropdownMenuItem
      (
          value: material.documentID,
          child: new Text(material.name)
      ));
    }
    return items;
  }

  void changedDropDownItemMaterial(String selectedMaterial)
  {
    setState(() {
      _currentMaterial = selectedMaterial; 
      print(_currentMaterial);
    });
  }


  void addStock(BuildContext context)
  {
    Stock stock = Stock();
    MyMaterial material = MyMaterial();

    material.documentID = _currentMaterial;

    stock.material = material;
    stock.amount = int.parse(controllerAmount.text);
    stock.price = int.parse(controllerPrice.text);

    int sum = int.parse(controllerAmount.text) * int.parse(controllerPrice.text);
    stock.sum = sum;
    Provider.of<AdapterStock>(context).add(stock);
  }

  void changeStock(BuildContext context)
  {
    Stock stock = Stock();
    MyMaterial material = MyMaterial();

    material.documentID = _currentMaterial;

    stock.documentID = widget.stock.documentID;
    stock.material = material;
    stock.amount = int.parse(controllerAmount.text);
    stock.price = int.parse(controllerPrice.text);

    int sum = int.parse(controllerAmount.text) * int.parse(controllerPrice.text);
    stock.sum = sum;
    Provider.of<AdapterStock>(context).change(stock);
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
          return AlertDialog
          (
            title: Text(widget.stock != null ? 'Редактирование ячейки' : 'Добавление ячейки'),
            content: Container
            (
              height: MediaQuery.of(context).size.height/4,
              child: Column
              (
                children: <Widget>
                [  
                  DropdownButton
                  (
                    value: _currentMaterial,
                    items: _dropDownMenuMaterials,
                    onChanged: changedDropDownItemMaterial,
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
                      hintText: 'Введите цену за штуку'
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