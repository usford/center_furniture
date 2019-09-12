
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:furniture_center/users/client/write_order.dart' as prefix0;

class AdapterWriteOrder with ChangeNotifier
{
  List<WriteOrder> _writeOrders = List<WriteOrder>();

  AdapterWriteOrder()
  {
    Firestore.instance.collection('write_orders').snapshots().listen((snapshotData) async
    {
      if (snapshotData != null)
      {
        snapshotData.documentChanges.forEach((documentChange) async 
        {
          switch(documentChange.type.toString())
          {
            case 'DocumentChangeType.added':
            {
              WriteOrder writeOrder = WriteOrder();
              writeOrder.documentID = documentChange.document.documentID;
              writeOrder.text = documentChange.document.data['text'];
              writeOrder.clientID = documentChange.document.data['clientID'];
              _writeOrders.add(writeOrder);
              notifyListeners();
              break;
            }

            case 'DocumentChangeType.removed':
            {
              _writeOrders.remove(WriteOrder(documentID: documentChange.document.documentID));
              notifyListeners();
              break;
            }
          }
        });
      }
    });
  }

  List<WriteOrder> get writeOrders
  {
    return _writeOrders;
  }

  set writeOrder(List<WriteOrder> writeOrders)
  {
    _writeOrders = writeOrders;
  }

  void add(String text, String clientID)
  {
    Firestore.instance.collection('write_orders').add(
    {
      'text': text,
      'clientID': clientID,
    }
    );
  }
}

class WriteOrder 
{
  String documentID;
  String text;
  String clientID;

  bool operator ==(o) =>
      o is WriteOrder && o.documentID == documentID;

  WriteOrder
  (
    {
      this.documentID,
      this.text,
      this.clientID
    }
  );
}