
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_center/Adapters/adapter_material.dart';
import 'package:furniture_center/Adapters/adapter_provider.dart';
import 'package:furniture_center/Adapters/adapter_purchase.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_change_cell.dart';
import 'package:provider/provider.dart';

class TablePurchases extends StatefulWidget
{
  @override
  _StateTablePurchases createState() => _StateTablePurchases();
}

class _StateTablePurchases extends State<TablePurchases>
{ 
  List<MyProvider> _providers;
  List<MyMaterial> _materials;
  void visibleAddPurchase()
  {
    showDialog(
      context: context,
      builder: (context)
      {
        return DialogAddPurchase(providers: _providers, materials: _materials,);
      }
    );
  }

  void changeCell(String choice, String id, BuildContext context, Purchase purchase)
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
            return DialogAddPurchase(nameButton: "Редактировать", purchase: purchase, materials: _materials, providers: _providers,);
          }
        );
        break;
      }

      case PopupMenuChangeCell.delete:
      {
        //print('Удалить');
        Provider.of<AdapterPurchase>(context).remove(id);
        break;
      }
    }
  }

  void getProvider(BuildContext context)
  {
    _providers = List<MyProvider>();
    Provider.of<AdapterProvider>(context).providers.forEach((provider)
    {
      //print(provider.documentID);
      _providers.add(
        MyProvider
        (
          documentID: provider.documentID,
          name: provider.name,
          phone: provider.phone
        )
      );
    });
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
    getProvider(context);
    getMaterial(context);
    return Consumer<AdapterPurchase>
    (
      builder: (context, value, child)
      {
        return Scaffold
        (
          body: Center
          (
            child: ListView.builder(
              itemCount: value.purchases.length,
              itemBuilder: (BuildContext context, int index)
              {
                Purchase purchase = Purchase();
                purchase = value.purchases[index];
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
                                Text('Поставщик:', textAlign: TextAlign.center,),
                                Text('${value.purchases[index].provider.name}', textAlign: TextAlign.center,)
                              ]
                            ),

                            TableRow
                            (
                              children: <Widget>
                              [
                                Text('Материал:', textAlign: TextAlign.center,),
                                Text('${value.purchases[index].material.name}', textAlign: TextAlign.center,)
                              ]
                            ),

                            TableRow
                            (
                              children: <Widget>
                              [
                                Text('Количество материала:', textAlign: TextAlign.center,),
                                Text('${value.purchases[index].amount}', textAlign: TextAlign.center,)
                              ]
                            ),

                            TableRow
                            (
                              children: <Widget>
                              [
                                Text('Дата поставки:', textAlign: TextAlign.center,),
                                Text('${value.purchases[index].date}', textAlign: TextAlign.center,)
                              ]
                            ),

                            TableRow
                            (
                              children: <Widget>
                              [
                                Text('Затраты:', textAlign: TextAlign.center,),
                                Text('${value.purchases[index].price} руб.', textAlign: TextAlign.center,)
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
                                    changeCell(choice, value.purchases[index].documentID, context, purchase);
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

class DialogAddPurchase extends StatefulWidget
{
  final String nameButton;
  final Purchase purchase;
  final List<MyProvider> providers;
  final List<MyMaterial> materials;

  DialogAddPurchase({this.nameButton = "Добавить", this.purchase, this.providers, this.materials});
  @override
  _StateDialogAddPurchase createState() => _StateDialogAddPurchase();
}

class _StateDialogAddPurchase extends State<DialogAddPurchase>
{
  TextEditingController controllerAmount = TextEditingController();
  TextEditingController controllerDate = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();

  
  List<MyProvider> _providers;
  List<MyMaterial> _materials;

  List<DropdownMenuItem<String>> _dropDownMenuProviders;
  List<DropdownMenuItem<String>> _dropDownMenuMaterials;

  String _currentProvider;
  String _currentMaterial;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _providers = List<MyProvider>();
    _providers = widget.providers;
    _dropDownMenuProviders = getDropDownMenuProviders();
    _currentProvider = _dropDownMenuProviders[0].value;

    _materials = List<MyMaterial>();
    _materials = widget.materials;
    _dropDownMenuMaterials = getDropDownMenuMaterials();
    _currentMaterial = _dropDownMenuMaterials[0].value;

    if (widget.purchase != null)
    {
      _currentProvider = widget.purchase.provider.documentID;
      _currentMaterial = widget.purchase.material.documentID;
      controllerAmount.text = widget.purchase.amount.toString();
      controllerDate.text = widget.purchase.date;
      controllerPrice.text = widget.purchase.price.toString();
    }
  }
  

  List<DropdownMenuItem<String>> getDropDownMenuProviders()
  {
    List<DropdownMenuItem<String>> items = new List();
    for (MyProvider provider in _providers) 
    {
      items.add(new DropdownMenuItem
      (
          value: provider.documentID,
          child: new Text(provider.name)
      ));
    }
    return items;
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

  void changedDropDownItemProvider(String selectedProvider)
  {
    setState(() {
      _currentProvider = selectedProvider; 
    });
  }

  void changedDropDownItemMaterial(String selectedMaterial)
  {
    setState(() {
      _currentMaterial = selectedMaterial; 
      print(_currentMaterial);
    });
  }

  void addPurchase(BuildContext context)
  {
    Purchase purchase = Purchase();
    MyMaterial material = MyMaterial();
    MyProvider provider = MyProvider();

    material.documentID = _currentMaterial;
    provider.documentID = _currentProvider;

    purchase.provider = provider;
    purchase.material = material;
    purchase.amount = int.parse(controllerAmount.text);
    purchase.date = controllerDate.text;
    purchase.price = int.parse(controllerPrice.text);

    Provider.of<AdapterPurchase>(context).add(purchase);
  }

  void changePurchase(BuildContext context)
  {
    Purchase purchase = Purchase();
    MyMaterial material = MyMaterial();
    MyProvider provider = MyProvider();

    material.documentID = _currentMaterial;
    provider.documentID = _currentProvider;


    purchase.documentID = widget.purchase.documentID;
    purchase.provider = provider;
    purchase.material = material;
    purchase.amount = int.parse(controllerAmount.text);
    purchase.date = controllerDate.text;
    purchase.price = int.parse(controllerPrice.text);

    Provider.of<AdapterPurchase>(context).change(purchase);
  }
  
  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider<AdapterPurchase>
    (
      builder: (_) => AdapterPurchase(),
      child: Consumer<AdapterPurchase>
      (
        builder: (context, value, child)
        {
          return AlertDialog
          (
            title: Text(widget.purchase != null ? 'Редактирование закупки' : 'Добавление закупки'),
            content: Container
            (
              height: MediaQuery.of(context).size.height/2.5,
              child: Column
              (
                children: <Widget>
                [
                  DropdownButton
                  (
                    value: _currentProvider,
                    items: _dropDownMenuProviders,
                    onChanged: changedDropDownItemProvider,
                  ),

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
                      hintText: 'Введите дату поставки'
                    ),
                    controller: controllerDate,
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
                      addPurchase(context);
                      break;
                    
                    case "Редактировать":
                      changePurchase(context);
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