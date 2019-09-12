
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:furniture_center/Adapters/adapter_material.dart';

class AdapterStock with ChangeNotifier
{
  List<Stock> _stock = List<Stock>();
  Completer stockUploaded;

  AdapterStock()
  {
    Firestore.instance.collection('stock').snapshots().listen((snapshotData) async
    {
      if (snapshotData != null)
      {
        snapshotData.documentChanges.forEach((documentChange) async 
        {
          switch(documentChange.type.toString())
          {
            case 'DocumentChangeType.added':
            {
              Stock stock = Stock();

              stock.documentID = documentChange.document.documentID;
              stock.material = documentChange.document.data['material'];
              stock.amount = documentChange.document.data['amount'];
              stock.price = documentChange.document.data['price'];
              stock.sum = documentChange.document.data['sum'];

              notifyListeners();

              break;
            }

            case 'DocumentChangeType.removed': 
            {
              _stock.remove(Stock(documentID: documentChange.document.documentID));
              notifyListeners();
              break;
            }

            case 'DocumentChangeType.modified':
            {
              _stock.forEach((stock)
              {
                if (stock.documentID == documentChange.document.documentID)
                {
                  stock.material = documentChange.document.data['material'];
                  stock.amount = documentChange.document.data['amount'];
                  stock.price = documentChange.document.data['price'];
                  stock.sum = documentChange.document.data['sum'];
                }
              });
              notifyListeners();
              break;
            }
          }
        });
      }
    });
  }

  List<Stock> get stock
  {
    return _stock;
  }

  set stock(List<Stock> users)
  {
    _stock = stock;
  }

  void add(Stock stock)
  {
    stockUploaded = Completer();

    Firestore.instance.collection('stock').add(
      {
        'material': stock.material.documentID,
        'amount': stock.amount,
        'price': stock.price,
        'sum': stock.price
      }
    );

    stockUploaded.complete();
  }

  void remove(String stockID)
  {
    stockUploaded = Completer();

    Firestore.instance.collection('stock').document(stockID).delete();

    stockUploaded.complete();
  }

  void changeUser(Stock stock)
  {
    Firestore.instance.collection('users').document(stock.documentID).updateData(
    {
      'material': stock.material.documentID,
      'amount': stock.amount,
      'price': stock.price,
      'sum': stock.price
    }
    );
  }
}

class Stock 
{
  String documentID;
  MyMaterial material;
  int amount;
  int price;
  int sum;

  bool operator ==(o) =>
      o is Stock && o.documentID == documentID;

  Stock
  (
    {
      this.documentID,
      this.material,
      this.amount,
      this.price,
      this.sum
    }
  );
}