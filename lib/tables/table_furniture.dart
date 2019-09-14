
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_center/Adapters/adapter_furniture.dart';
import 'package:furniture_center/Adapters/adapter_material.dart';
import 'package:furniture_center/Adapters/adapter_materials_furniture.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_change_cell.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_fruniture.dart';
import 'package:provider/provider.dart';

class TableFurniture extends StatefulWidget
{
  @override
  _StateTableFurniture createState() => _StateTableFurniture();
}

class _StateTableFurniture extends State<TableFurniture>
{ 
  List<MyMaterial> _materials;
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
      case PopupMenuFurniture.edit:
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

      case PopupMenuFurniture.delete:
      {
        print('Удалить');
        Provider.of<AdapterFurniture>(context).remove(id);
        break;
      }

      case PopupMenuFurniture.materials:
      {
        showDialog(
          context: context,
          builder: (BuildContext context)
          {
            return DialogMaterials(furniture: furniture, materials: _materials);
          }
        );
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
                              return PopupMenuFurniture.choices.map((String choice)
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
              height: MediaQuery.of(context).size.height/4,
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

class DialogMaterials extends StatefulWidget
{
  final Furniture furniture;
  final List<MyMaterial> materials;
  DialogMaterials({this.furniture, this.materials});
  @override
  _StateDialogMaterials createState() => _StateDialogMaterials();
}

class _StateDialogMaterials extends State<DialogMaterials>
{
  void changeCell(String choice, String id, BuildContext context, Furniture furniture, MyMaterial material)
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
        Provider.of<AdapterMaterialsFurniture>(context).remove(material.documentID, furniture);
        break;
      }
    }
  }
  void visibleAddMaterials()
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return DialogAddMaterial(materials: widget.materials, furniture: widget.furniture,);
      }
    );
  }
  @override
  Widget build(BuildContext context)
  {
    
    return ChangeNotifierProvider<AdapterMaterialsFurniture>
    (
      builder: (_) => AdapterMaterialsFurniture(furnitureID: widget.furniture.documentID),
      child: Consumer<AdapterMaterialsFurniture>
      (
        builder: (context, value, child)
        {
          return Scaffold
          (
            appBar: AppBar
            (
              title: Text("${widget.furniture.name}"),
              actions: <Widget>
              [
                
              ],
            ),
            body: Center
            (
              child: ListView.builder(
                itemCount: value.materials.length,
                itemBuilder: (BuildContext context, int index)
                {
                  MyMaterial material = MyMaterial();
                  material = value.materials[index];
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
                                  Text('Название материала:', textAlign: TextAlign.center,),
                                  Text('${material.name}', textAlign: TextAlign.center,)
                                ]
                              ),

                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('Из чего сделан:', textAlign: TextAlign.center,),
                                  Text('${material.fabric}', textAlign: TextAlign.center,)
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
                                      changeCell(choice, value.materials[index].documentID, context, widget.furniture, material);
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
                visibleAddMaterials();
              },
              child: Icon
              (
                Icons.add
              ),
            ),
          );
        },
      ),
    );
  }
}

class DialogAddMaterial extends StatefulWidget
{
  final String nameButton;
  final MyMaterial material;
  final List<MyMaterial> materials;
  final Furniture furniture;

  DialogAddMaterial({this.nameButton = "Добавить", this.material, this.materials, this.furniture});
  @override
  _StateDialogAddMaterial createState() => _StateDialogAddMaterial();
}

class _StateDialogAddMaterial extends State<DialogAddMaterial>
{
  AdapterMaterial adapterMaterial;
  AdapterMaterialsFurniture adapterMaterialsFurniture;
  List<MyMaterial> _materials;
  List<DropdownMenuItem<String>> _dropDownMenuMaterials;
  String _currentMaterial;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _materials = List<MyMaterial>();
    _materials = widget.materials;
    _dropDownMenuMaterials = getDropDownMenuMaterials();
    _currentMaterial = _dropDownMenuMaterials[0].value;
    adapterMaterial = AdapterMaterial();
    adapterMaterialsFurniture = AdapterMaterialsFurniture(furnitureID: widget.furniture.documentID);
  }

  void addMaterial(BuildContext context)
  {
    MyMaterial material = MyMaterial();
    List<MyMaterial> materials =  Provider.of<AdapterMaterial>(context).materials.where((material) => material.documentID == _currentMaterial).toList();

    material = materials[0];

    Provider.of<AdapterMaterialsFurniture>(context).add(widget.furniture, material);
  }

  void changeMaterial(BuildContext context)
  {
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
  
  @override
  Widget build(BuildContext context)
  {
    var providers = <SingleChildCloneableWidget>
    [
      ChangeNotifierProvider<AdapterMaterial>.value(
        value: adapterMaterial,
      ),
      ChangeNotifierProvider<AdapterMaterialsFurniture>.value(
        value: adapterMaterialsFurniture,
      ),
    ];
    return MultiProvider
    (
      providers: providers,
      child: Consumer<AdapterMaterialsFurniture>
      (
        builder: (context, value, child)
        {
          return AlertDialog
          (
            title: Text(widget.material != null ? 'Редактирование материала' : 'Добавление материала'),
            content: Container
            (
              height: MediaQuery.of(context).size.height/7,
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
                      addMaterial(context);
                      break;
                    
                    case "Редактировать":
                      changeMaterial(context);
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