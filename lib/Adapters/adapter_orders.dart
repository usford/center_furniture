
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:furniture_center/Adapters/adapter_furniture.dart';
import 'package:furniture_center/Adapters/adapter_users.dart';


class AdapterOrders with ChangeNotifier
{
  List<Order> _orders = List<Order>();
  Completer ordersUploaded;

  AdapterOrders()
  {
    Firestore.instance.collection('orders').snapshots().listen((snapshotData) async
    {
      if (snapshotData != null)
      {
        snapshotData.documentChanges.forEach((documentChange) async 
        {
          switch(documentChange.type.toString())
          {
            case 'DocumentChangeType.added':
            {
              Order order = Order();
              User user = User();
              Furniture furniture = Furniture();

              order.documentID = documentChange.document.documentID;

              await Firestore.instance.collection('users').getDocuments().then((body)
              {
                body.documents.forEach((doc)
                {
                  if (doc.documentID == documentChange.document.data['client'])
                  {
                    user.documentID = doc.documentID;
                    user.email = doc.data['email'];
                    user.password = doc.data['password'];
                  }
                });
              });

              order.user = user;

              await Firestore.instance.collection('furnitures').getDocuments().then((body)
              {
                body.documents.forEach((doc)
                {
                  if (doc.documentID == documentChange.document.data['furniture'])
                  {
                    furniture.documentID = doc.documentID;
                    furniture.name = doc.data['name'];
                    furniture.amount = doc.data['amount'];
                    furniture.price = doc.data['price'];
                  }
                });
              });

              order.furniture = furniture;

              order.price = documentChange.document.data['price'];

              _orders.add(order);
              try
              {
                notifyListeners();
              }catch (e)
              {
                print(e);
              }   
              break;
            }

            case 'DocumentChangeType.removed': 
            {
              _orders.remove(Order(documentID: documentChange.document.documentID));
              try
              {
                notifyListeners();
              }catch (e)
              {
                print(e);
              }
              break;
            }

            case 'DocumentChangeType.modified':
            {         
              break;
            }
          }
        });
      }
    });
  }

  List<Order> get orders
  {
    return _orders;
  }

  set orders(List<Order> orders)
  {
    _orders = orders;
  }

  void add(Order order)
  {
    ordersUploaded = Completer();

    Firestore.instance.collection('orders').add(
      {
        'client': order.user.documentID,
        'furniture': order.furniture.documentID,
        'price': order.price
      }
    );

    ordersUploaded.complete();
  }

  void remove(String orderID)
  {
    ordersUploaded = Completer();

    Firestore.instance.collection('orders').document(orderID).delete();

    ordersUploaded.complete();
  }

  void change(Order order)
  {
    ordersUploaded = Completer();

    Firestore.instance.collection('orders').document(order.documentID).updateData(
      {
        'client': order.user.documentID,
        'furniture': order.furniture.documentID,
        'price': order.price
      }
    );
    
    ordersUploaded.complete();
  }
}

class Order 
{
  String documentID;
  User user;
  Furniture furniture;
  int price;

  bool operator ==(o) =>
      o is Order && o.documentID == documentID;

  Order
  (
    {
      this.documentID,
      this.user,
      this.furniture,
      this.price,
    }
  );
}