
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  void visibleAddUser()
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return DialogAddUser();
      }
    );
  }

  void changeCell(String choice, String id, BuildContext context, User user)
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
            return DialogAddUser(nameButton: "Редактировать", textEmail: user.email, textPassword: user.password, userID: user.documentID, user: user, curType: user.type,);
          }
        );
        break;
      }

      case PopupMenuChangeCell.delete:
      {
        print('Удалить');
        Provider.of<AdapterUser>(context).remove(id);
        break;
      }
    }
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
          return Scaffold
          (
            body: Center
            (
              child: ListView.builder(
                itemCount: value.users.length,
                itemBuilder: (BuildContext context, int index)
                {
                  User user = User();
                  user = value.users[index];
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
                                  Text('Тип пользователя:', textAlign: TextAlign.center,),
                                  Text('${value.users[index].type}', textAlign: TextAlign.center,)
                                ]
                              ),

                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('Email:', textAlign: TextAlign.center,),
                                  Text('${value.users[index].email}', textAlign: TextAlign.center,)
                                ]
                              ),

                              TableRow
                              (
                                children: <Widget>
                                [
                                  Text('Пароль:', textAlign: TextAlign.center,),
                                  Text('${value.users[index].password}', textAlign: TextAlign.center,)
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
                                      changeCell(choice, value.users[index].documentID, context, user);
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
                visibleAddUser();
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

class DialogAddUser extends StatefulWidget
{
  final String textEmail;
  final String textPassword;
  final String userID;
  final String nameButton;
  final String curType;
  final User user;
  DialogAddUser({this.textEmail = "", this.textPassword = "", this.nameButton = "Добавить", this.userID = "", this.user, this.curType});
  @override
  _StateDialogAddUser createState() => _StateDialogAddUser();
}

class _StateDialogAddUser extends State<DialogAddUser>
{
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  String _currentType;
  List _userTypes = ["Admin", "Client", "Manager"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dropDownMenuItems = getDropDownMenuItems();
    _currentType = _dropDownMenuItems[0].value;

    if (widget.curType != null)
    {
      _currentType = widget.curType;
    }

    controllerEmail.text = widget.textEmail;
    controllerPassword.text = widget.textPassword;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems()
  {
    List<DropdownMenuItem<String>> items = new List();
    for (String type in _userTypes) 
    {
      items.add(new DropdownMenuItem
      (
          value: type,
          child: new Text(type)
      ));
    }
    return items;
  }

  void changedDropDownItem(String selectedType)
  {
    setState(() {
      _currentType = selectedType; 
    });
  }

  void addUser(BuildContext context)
  {
    User user = User();

    user.email = controllerEmail.text;
    user.password = controllerPassword.text;
    user.type = _currentType;
    
    Provider.of<AdapterUser>(context).add(user);
  }

  void changeUser(BuildContext context)
  {
    User user = User();
    user.type = _currentType;
    user.email = controllerEmail.text;
    user.password = controllerPassword.text;
    user.documentID = widget.userID;
    
    Provider.of<AdapterUser>(context).changeUser(user);
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
            title: Text(widget.user != null ? 'Редактирование пользовател' : 'Добавление пользователя'),
            content: Container
            (
              height: MediaQuery.of(context).size.height/4,
              child: Column
              (
                children: <Widget>
                [
                  DropdownButton
                  (
                    value: _currentType,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem,
                  ),
                  TextField
                  (
                    decoration: InputDecoration
                    (
                      hintText: 'Введите email'
                    ),
                    controller: controllerEmail,
                  ),

                  TextField
                  (
                    decoration: InputDecoration
                    (
                      hintText: 'Введите пароль'
                    ),
                    controller: controllerPassword,
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
                      addUser(context);
                      break;
                    
                    case "Редактировать":
                      changeUser(context);
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