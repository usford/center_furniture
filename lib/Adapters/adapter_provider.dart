
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdapterProvider with ChangeNotifier
{
  List<MyProvider> _providers = List<MyProvider>();
  Completer providersUploaded;

  AdapterProvider()
  {
    Firestore.instance.collection('providers').snapshots().listen((snapshotData) async
    {
      if (snapshotData != null)
      {
        snapshotData.documentChanges.forEach((documentChange) async 
        {
          switch(documentChange.type.toString())
          {
            case 'DocumentChangeType.added':
            {
              MyProvider provider = MyProvider();
              
              provider.documentID = documentChange.document.documentID;
              provider.name = documentChange.document.data['name'];
              provider.phone = documentChange.document.data['phone'];

              _providers.add(provider);
              notifyListeners();

              break;
            }

            case 'DocumentChangeType.removed': 
            {
              _providers.remove(MyProvider(documentID: documentChange.document.documentID));
              notifyListeners();
              break;
            }

            case 'DocumentChangeType.modified':
            {
              print('Изменено');

              _providers.forEach((provider)
              {
                if (documentChange.document.documentID == provider.documentID)
                {
                  provider.name = documentChange.document.data['name'];
                  provider.phone = documentChange.document.data['phone'];
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

  List<MyProvider> get providers
  {
    return _providers;
  }

  set provider(List<MyProvider> providers)
  {
    _providers = providers;
  }

  void add(MyProvider provider)
  {
    providersUploaded = Completer();

    if (provider.documentID != null)
    {
      Firestore.instance.collection('providers').document(provider.documentID).setData(
      {
        'name' : provider.name,
        'phone': provider.phone,
      });
    }else
    {
      Firestore.instance.collection('providers').add(
      {
        'name' : provider.name,
        'phone': provider.phone,
      });
    }

    providersUploaded.complete();
  }

  void remove(String providerID)
  {
    providersUploaded = Completer();

    Firestore.instance.collection('providers').document(providerID).delete();

    providersUploaded.complete();
  }

  void change(MyProvider provider)
  {
    Firestore.instance.collection('providers').document(provider.documentID).updateData(
    {
      'name': provider.name,
      'phone': provider.phone,
    }
    );
    notifyListeners();
  }
}

class MyProvider 
{
  String documentID;
  String name;
  String phone;

  bool operator ==(o) =>
      o is MyProvider && o.documentID == documentID;

  MyProvider
  (
    {
      this.documentID,
      this.name,
      this.phone,
    }
  );
}