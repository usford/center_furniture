
import 'package:flutter/material.dart';
import 'package:furniture_center/Adapters/adapter_users.dart';
import 'package:provider/provider.dart';

class WorkspaceRegistration extends StatefulWidget
{
  @override
  _StateWorkspaceRegistration createState() => _StateWorkspaceRegistration();
}

class _StateWorkspaceRegistration extends State <WorkspaceRegistration>
{
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  void check()
  {
    User user = User();
    user.email = controllerEmail.text;
    user.password = controllerPassword.text;
    user.type = "Client";

    Provider.of<AdapterUser>(context).add(user);
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      home: Scaffold
      (
        body: Center
        (
          child: Container
          (
            width: MediaQuery.of(context).size.width/2,
            child: Column
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>
              [
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

                FlatButton
                (
                  color: Colors.blue,
                  onPressed: () => check(),
                  child: Text
                  (
                    'Зарегистрироваться',
                    style: TextStyle
                    (
                      color: Colors.white
                    ),
                  ),
                ),

                FlatButton
                (
                  color: Colors.blue,
                  onPressed: () => Navigator.pop(context),
                  child: Text
                  (
                    'Назад',
                    style: TextStyle
                    (
                      color: Colors.white
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}