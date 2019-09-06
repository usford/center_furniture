
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  void visibleAddPurchase()
  {
    showDialog(
      context: context,
      builder: (context)
      {
        return DialogAddPurchase(providers: _providers,);
      }
    );
  }

  void changeCell(String choice, String id, BuildContext context, Purchase purchase)
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
            return DialogAddPurchase(nameButton: "Редактировать", purchase: purchase,);
          }
        );
        break;
      }

      case PopupMenuChangeCell.delete:
      {
        print('Удалить');
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

  @override
  Widget build(BuildContext context)
  {
    getProvider(context);
    return ChangeNotifierProvider<AdapterPurchase>
    (
      builder: (_) => AdapterPurchase(),
      child: Consumer<AdapterPurchase>
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
      )
    );
  }
}

class DialogAddPurchase extends StatefulWidget
{
  final String nameButton;
  final Purchase purchase;
  final List<MyProvider> providers;

  DialogAddPurchase({this.nameButton = "Добавить", this.purchase, this.providers});
  @override
  _StateDialogAddPurchase createState() => _StateDialogAddPurchase();
}

class _StateDialogAddPurchase extends State<DialogAddPurchase>
{
  TextEditingController controllerAmount = TextEditingController();
  TextEditingController controllerDate = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();

  
  List<MyProvider> _providers;
  List _materials;

  List<DropdownMenuItem<String>> _dropDownMenuProviders;
  List<DropdownMenuItem<String>> _dropDownMenuMaterials;

  String _currentProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.purchase != null)
    {
    }
    _providers = List<MyProvider>();
    _providers = widget.providers;
    _dropDownMenuProviders = getDropDownMenuProviders();
    _currentProvider = _dropDownMenuProviders[0].value;
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

  void changedDropDownItemProvider(String selectedProvider)
  {
    setState(() {
      _currentProvider = selectedProvider; 
    });
  }

  void addPurchase(BuildContext context)
  {
  }

  void changePurchase(BuildContext context)
  {
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
              height: MediaQuery.of(context).size.height/3,
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