
import 'package:flutter/material.dart';
import 'package:furniture_center/Adapters/adapter_users.dart';
import 'package:furniture_center/Adapters/adapter_write_orders.dart';
import 'package:furniture_center/global_state.dart';
import 'package:provider/provider.dart';

class WriteOrder extends StatefulWidget
{
  _StateWriteOrder createState() => _StateWriteOrder();
}

class _StateWriteOrder extends State<WriteOrder>
{
  TextEditingController controllerOrder = TextEditingController();

  GlobalState _globalState = GlobalState();


  void send(BuildContext context)
  {
    Provider.of<AdapterWriteOrder>(context).add(controllerOrder.text, _globalState.user.documentID);
    setState(() {
     controllerOrder.text = ""; 
    });
  }
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider<AdapterWriteOrder>
    (
      builder: (_) => AdapterWriteOrder(),
      child: Consumer<AdapterWriteOrder>
      (
        builder: (context, value, child)
        {
          return Scaffold
          (
            body: Column
            (
              children: <Widget>
              [
                TextField
                (
                  decoration: InputDecoration
                  (
                    hintText: 'Введите ваши пожелания'
                  ),
                  controller: controllerOrder,
                ), 

                FlatButton
                (
                  color: Colors.blue,
                  onPressed: () => send(context),
                  child: Text('Отправить', style: TextStyle(color: Colors.white),),
                )
              ],
            )
          );
        },
      ),
    );
  }
}