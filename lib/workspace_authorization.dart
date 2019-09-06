
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_center/Adapters/adapter_authorization.dart';
import 'package:provider/provider.dart';

class WorkspaceAuthorization extends StatefulWidget
{
  @override
  _WorkspaceAuthorizationState createState() => _WorkspaceAuthorizationState();
}

class _WorkspaceAuthorizationState extends State<WorkspaceAuthorization>
{
  AdapterAuthorization adapterAuthorization = AdapterAuthorization();

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  
  @override
  Widget build(BuildContext context)
  {
    return Center
    (
      child: Container
      (
        width: MediaQuery.of(context).size.width/2,
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.center,
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

            Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>
              [
                FlatButton
                (
                  onPressed: (){},
                  child: Container
                  (
                    alignment: Alignment.centerLeft,
                    child: Text
                    (
                      'Забыли пароль?',
                      style: TextStyle
                      (
                        fontSize: 10,
                        color: Colors.blue
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),

                FlatButton
                (
                  onPressed: (){},
                  child: Text
                  (
                    'Регистрация',
                    style: TextStyle
                    (
                      fontSize: 10,
                      color: Colors.blue
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),

            FlatButton
            (
              color: Colors.blue,
              onPressed: () => Provider.of<AdapterAuthorization>(context).checkAuthorization(controllerEmail.text, controllerPassword.text),
              child: Text
              (
                'Авторизоваться',
                style: TextStyle
                (
                  color: Colors.white
                ),
              ),
            )
          ],
        ),
      )
    );  
  }
}