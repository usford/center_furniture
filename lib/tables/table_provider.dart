
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_center/Adapters/adapter_provider.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_change_cell.dart';
import 'package:provider/provider.dart';

class TableProviders extends StatefulWidget
{
  @override
  _StateTableProviders createState() => _StateTableProviders();
}

class _StateTableProviders extends State<TableProviders>
{ 
  void visibleAddProvider()
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return DialogAddProvider();
      }
    );
  }

  void changeCell(String choice, String id, BuildContext context, MyProvider provider)
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
            return DialogAddProvider(nameButton: "Редактировать", provider: provider,);
          }
        );
        break;
      }

      case PopupMenuChangeCell.delete:
      {
        print('Удалить');
        Provider.of<AdapterProvider>(context).remove(id);
        break;
      }
    }
  }
  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider<AdapterProvider>
    (
      builder: (_) => AdapterProvider(),
      child: Consumer<AdapterProvider>
      (
        builder: (context, value, child)
        {
          return Scaffold
          (
            body: Center
            (
              child: ListView.builder(
                itemCount: value.providers.length,
                itemBuilder: (BuildContext context, int index)
                {
                  MyProvider provider = MyProvider();
                  provider = value.providers[index];
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
                                  Text('Название организации:', textAlign: TextAlign.center,),
                                  Text('${value.providers[index].name}', textAlign: TextAlign.center,)
                                ]
                              ),

                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('Номер телефона:', textAlign: TextAlign.center,),
                                  Text('${value.providers[index].phone}', textAlign: TextAlign.center,)
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
                                      changeCell(choice, value.providers[index].documentID, context, provider);
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
                visibleAddProvider();
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

class DialogAddProvider extends StatefulWidget
{
  final String nameButton;
  final MyProvider provider;

  DialogAddProvider({this.nameButton = "Добавить", this.provider});
  @override
  _StateDialogAddProvider createState() => _StateDialogAddProvider();
}

class _StateDialogAddProvider extends State<DialogAddProvider>
{
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();

  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.provider != null)
    {
      controllerName.text = widget.provider.name;
      controllerPhone.text = widget.provider.phone;
    }
  }

  void addProvider(BuildContext context)
  {
    MyProvider provider = MyProvider();

    provider.name = controllerName.text;
    provider.phone = controllerPhone.text;
    
    Provider.of<AdapterProvider>(context).add(provider);
  }

  void changeProvider(BuildContext context)
  {
    MyProvider provider = MyProvider();
    provider.name = controllerName.text;
    provider.phone = controllerPhone.text;
    provider.documentID = widget.provider.documentID;
    
    Provider.of<AdapterProvider>(context).change(provider);
  }
  
  @override
  Widget build(BuildContext context)
  {

    return ChangeNotifierProvider<AdapterProvider>
    (
      builder: (_) => AdapterProvider(),
      child: Consumer<AdapterProvider>
      (
        builder: (context, value, child)
        {
          return AlertDialog
          (
            title: Text(widget.provider != null ? 'Редактирование поставщика' : 'Добавление поставщика'),
            content: Container
            (
              height: MediaQuery.of(context).size.height/7,
              child: Column
              (
                children: <Widget>
                [
                  TextField
                  (
                    decoration: InputDecoration
                    (
                      hintText: 'Введите название организации'
                    ),
                    controller: controllerName,
                  ),

                  TextField
                  (
                    decoration: InputDecoration
                    (
                      hintText: 'Введите номер телефона'
                    ),
                    controller: controllerPhone,
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
                      addProvider(context);
                      break;
                    
                    case "Редактировать":
                      changeProvider(context);
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