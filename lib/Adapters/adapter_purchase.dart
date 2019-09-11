
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:furniture_center/Adapters/adapter_material.dart';

import 'adapter_provider.dart';

class AdapterPurchase with ChangeNotifier
{
  List<Purchase> _purchases = List<Purchase>();
  Completer purchasesUploaded;

  AdapterPurchase()
  {
    Firestore.instance.collection('purchases').snapshots().listen((snapshotData) async
    {
      if (snapshotData != null)
      {
        snapshotData.documentChanges.forEach((documentChange) async 
        {
          switch(documentChange.type.toString())
          {
            case 'DocumentChangeType.added':
            {
              print('добавленоыы');
              Purchase purchase = Purchase();
              MyProvider provider = MyProvider();
              MyMaterial material = MyMaterial();
              
              purchase.documentID = documentChange.document.documentID;
              
              await Firestore.instance.collection('providers').getDocuments().then((body)
              {
                body.documents.forEach((doc)
                {
                  if (doc.documentID == documentChange.document.data['provider'])
                  {
                    provider.documentID = documentChange.document.data['provider'];
                    provider.name = doc.data['name'];
                    provider.phone = doc.data['phone'];
                  }
                });
              });

              purchase.provider = provider;

              await Firestore.instance.collection('materials').getDocuments().then((body)
              {
                body.documents.forEach((doc)
                {
                  // print('${doc.documentID} - ${documentChange.document.data['material']}');
                  // print('------------');
                  // print('${doc.documentID} - ${doc.data['name']}');
                  if (doc.documentID == documentChange.document.data['material'])
                  {
                    material.documentID = documentChange.document.data['material'];
                    material.name = doc.data['name'];
                    material.fabric = doc.data['fabric'];
                  }
                });
              });

              purchase.material = material;
              purchase.amount = documentChange.document.data['amount'];
              purchase.date = documentChange.document.data['date'];
              purchase.price = documentChange.document.data['price'];

              _purchases.add(purchase);
              notifyListeners();

              break;
            }

            case 'DocumentChangeType.removed': 
            {
              _purchases.remove(Purchase(documentID: documentChange.document.documentID));
              notifyListeners();
              break;
            }

            case 'DocumentChangeType.modified':
            {
              print('Изменено');
              MyProvider provider = MyProvider();
              MyMaterial material = MyMaterial();

              if (purchasesUploaded != null && !purchasesUploaded.isCompleted) {
                await purchasesUploaded.future;
              }

              // _purchases.forEach((purchase) async
              // {
              //   if (documentChange.document.documentID == purchase.documentID)
              //   {
              //     await Firestore.instance.collection('providers').getDocuments().then((body)
              //     {
              //       body.documents.forEach((doc)
              //       {
              //         if (doc.documentID == purchase.provider.documentID)
              //         {
              //           provider.documentID = documentChange.document.data['provider'];
              //           provider.name = doc.data['name'];
              //           provider.phone = doc.data['phone'];
              //           purchase.provider = provider;
              //         }
              //       });
              //     });

                  

              //     await Firestore.instance.collection('materials').getDocuments().then((body)
              //     {
              //       body.documents.forEach((doc)
              //       {
              //         //print('${doc.documentID} - ${purchase.material.documentID}');
              //         if (doc.documentID == purchase.material.documentID)
              //         {
              //           //print('найден материал');
              //           material.documentID = documentChange.document.data['material'];
              //           material.name = doc.data['name'];
              //           material.fabric = doc.data['fabric'];
              //           purchase.material = material;
              //         }
              //       });
              //     });

                  
              //     purchase.amount = documentChange.document.data['amount'];
              //     purchase.date = documentChange.document.data['date'];
              //     purchase.price = documentChange.document.data['price'];
              //   }
                
              // });
              notifyListeners(); 
              break;
            }
          }
        });
      }
    });
  }

  List<Purchase> get purchases
  {
    return _purchases;
  }

  set purchase(List<Purchase> purchases)
  {
    _purchases = purchases;
  }

  void add(Purchase purchase)
  {
    //purchasesUploaded = Completer();

    Firestore.instance.collection('purchases').add(
    {
      'provider' : purchase.provider.documentID,
      'material': purchase.material.documentID,
      'amount': purchase.amount,
      'date': purchase.date,
      'price': purchase.price
    });

    //purchasesUploaded.complete();
  }

  void remove(String purchaseID)
  {
    purchasesUploaded = Completer();

    Firestore.instance.collection('purchases').document(purchaseID).delete();

    purchasesUploaded.complete();
  }

  void change(Purchase purchase)
  {
    purchasesUploaded = Completer();
    Firestore.instance.collection('purchases').document(purchase.documentID).updateData(
    {
      'provider' : purchase.provider.documentID,
      'material': purchase.material.documentID,
      'amount': purchase.amount,
      'date': purchase.date,
      'price': purchase.price
    }
    );
    purchasesUploaded.complete();
  }
}

class Purchase 
{
  String documentID;
  MyProvider provider;
  MyMaterial material;
  int amount;
  String date;
  int price;

  bool operator ==(o) =>
      o is Purchase && o.documentID == documentID;

  Purchase
  (
    {
      this.documentID,
      this.provider,
      this.material,
      this.amount,
      this.date,
      this.price
    }
  );
}