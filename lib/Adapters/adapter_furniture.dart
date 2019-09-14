
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:furniture_center/Adapters/adapter_material.dart';

class AdapterFurniture with ChangeNotifier
{
  List<Furniture> _furnitures = List<Furniture>();
  Completer furnituresUploaded;

  AdapterFurniture()
  {
    Firestore.instance.collection('furnitures').snapshots().listen((snapshotData) async
    {
      if (snapshotData != null)
      {
        snapshotData.documentChanges.forEach((documentChange) async 
        {
          switch(documentChange.type.toString())
          {
            case 'DocumentChangeType.added':
            {
              Furniture furniture = Furniture();
              
              furniture.documentID = documentChange.document.documentID;
              furniture.name = documentChange.document.data['name'];
              furniture.amount = documentChange.document.data['amount'];
              furniture.price = documentChange.document.data['price'];

              _furnitures.add(furniture);
              notifyListeners();

              break;
            }

            case 'DocumentChangeType.removed': 
            {
              _furnitures.remove(Furniture(documentID: documentChange.document.documentID));
              notifyListeners();
              break;
            }

            case 'DocumentChangeType.modified':
            {
              print('Изменено');

              _furnitures.forEach((user)
              {
                if (documentChange.document.documentID == user.documentID)
                {
                  user.name = documentChange.document.data['name'];
                  user.amount = documentChange.document.data['amount'];
                  user.price = documentChange.document.data['price'];
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

  List<Furniture> get furnitures
  {
    return _furnitures;
  }

  set furniture(List<Furniture> furnitures)
  {
    _furnitures = furnitures;
  }

  void add(Furniture furniture)
  {
    furnituresUploaded = Completer();

    if (furniture.documentID != null)
    {
      Firestore.instance.collection('furnitures').document(furniture.documentID).setData(
      {
        'name' : furniture.name,
        'amount': furniture.amount,
        'price': furniture.price
      });
    }else
    {
      Firestore.instance.collection('furnitures').add(
      {
        'name' : furniture.name,
        'amount': furniture.amount,
        'price': furniture.price
      });
    }

    furnituresUploaded.complete();
  }

  void remove(String furnitureID)
  {
    furnituresUploaded = Completer();

    Firestore.instance.collection('furnitures').document(furnitureID).delete();

    furnituresUploaded.complete();
  }

  void change(Furniture furniture)
  {
    Firestore.instance.collection('furnitures').document(furniture.documentID).updateData(
    {
      'name': furniture.name,
      'amount': furniture.amount,
      'price': furniture.price
    }
    );
  }
}

class Furniture 
{
  String documentID;
  String name;
  int amount;
  int price;

  bool operator ==(o) =>
      o is Furniture && o.documentID == documentID;

  Furniture
  (
    {
      this.documentID,
      this.name,
      this.amount,
      this.price
    }
  );
}