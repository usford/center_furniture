
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_center/Adapters/adapter_material.dart';
import 'package:furniture_center/PopupsMenu/popup_menu_change_cell.dart';
import 'package:provider/provider.dart';

class TableMaterials extends StatefulWidget
{
  @override
  _StateTableMaterials createState() => _StateTableMaterials();
}

class _StateTableMaterials extends State<TableMaterials>
{ 
  void visibleAddMaterial()
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return DialogAddMaterial();
      }
    );
  }

  void changeCell(String choice, String id, BuildContext context, MyMaterial material)
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
            return DialogAddMaterial(nameButton: "Редактировать", material: material,);
          }
        );
        break;
      }

      case PopupMenuChangeCell.delete:
      {
        print('Удалить');
        Provider.of<AdapterMaterial>(context).remove(id);
        break;
      }
    }
  }
  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider<AdapterMaterial>
    (
      builder: (_) => AdapterMaterial(),
      child: Consumer<AdapterMaterial>
      (
        builder: (context, value, child)
        {
          return Scaffold
          (
            body: Center
            (
              child: ListView.builder(
                itemCount: value.materials.length,
                itemBuilder: (BuildContext context, int index)
                {
                  MyMaterial provider = MyMaterial();
                  provider = value.materials[index];
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
                                  Text('${value.materials[index].name}', textAlign: TextAlign.center,)
                                ]
                              ),

                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('Из чего сделан материал:', textAlign: TextAlign.center,),
                                  Text('${value.materials[index].fabric}', textAlign: TextAlign.center,)
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
                                      changeCell(choice, value.materials[index].documentID, context, provider);
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
                visibleAddMaterial();
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

class DialogAddMaterial extends StatefulWidget
{
  final String nameButton;
  final MyMaterial material;

  DialogAddMaterial({this.nameButton = "Добавить", this.material});
  @override
  _StateDialogAddMaterial createState() => _StateDialogAddMaterial();
}

class _StateDialogAddMaterial extends State<DialogAddMaterial>
{
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerFabric = TextEditingController();

  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.material != null)
    {
      controllerName.text = widget.material.name;
      controllerFabric.text = widget.material.fabric;
    }
  }

  void addMaterial(BuildContext context)
  {
    MyMaterial material = MyMaterial();

    material.name = controllerName.text;
    material.fabric = controllerFabric.text;
    
    Provider.of<AdapterMaterial>(context).add(material);
  }

  void changeMaterial(BuildContext context)
  {
    MyMaterial material = MyMaterial();
    material.name = controllerName.text;
    material.fabric = controllerFabric.text;
    material.documentID = widget.material.documentID;
    
    Provider.of<AdapterMaterial>(context).change(material);
  }
  
  @override
  Widget build(BuildContext context)
  {

    return ChangeNotifierProvider<AdapterMaterial>
    (
      builder: (_) => AdapterMaterial(),
      child: Consumer<AdapterMaterial>
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
                  TextField
                  (
                    decoration: InputDecoration
                    (
                      hintText: 'Введите название материала'
                    ),
                    controller: controllerName,
                  ),

                  TextField
                  (
                    decoration: InputDecoration
                    (
                      hintText: 'Из чего сделан материал'
                    ),
                    controller: controllerFabric,
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