
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:furniture_center/Adapters/adapter_furniture.dart';

class AdapterMaterial with ChangeNotifier
{
  List<MyMaterial> _materials= List<MyMaterial>();
  Completer materialsUploaded;

  AdapterMaterial()
  {
    Firestore.instance.collection('materials').snapshots().listen((snapshotData) async
    {
      if (snapshotData != null)
      {
        snapshotData.documentChanges.forEach((documentChange) async 
        {
          switch(documentChange.type.toString())
          {
            case 'DocumentChangeType.added':
            {
              MyMaterial material = MyMaterial();
              
              material.documentID = documentChange.document.documentID;
              material.name = documentChange.document.data['name'];
              material.fabric = documentChange.document.data['fabric'];
              

              _materials.add(material);
              notifyListeners();
              break;
            }

            case 'DocumentChangeType.removed': 
            {
              _materials.remove(MyMaterial(documentID: documentChange.document.documentID));
              notifyListeners();
              break;
            }

            case 'DocumentChangeType.modified':
            {
              print('Изменено');

              _materials.forEach((material)
              {
                if (documentChange.document.documentID == material.documentID)
                {
                  material.name = documentChange.document.data['name'];
                  material.fabric = documentChange.document.data['fabric'];
                  
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

  List<MyMaterial> get materials
  {
    return _materials;
  }

  set material(List<MyMaterial> materials)
  {
    _materials = materials;
  }

  void add(MyMaterial material)
  {
    materialsUploaded = Completer();

    if (material.documentID != null)
    {
      Firestore.instance.collection('materials').document(material.documentID).setData(
      {
        'name' : material.name,
        'fabric': material.fabric,
      });
    }else
    {
      Firestore.instance.collection('materials').add(
      {
        'name' : material.name,
        'fabric': material.fabric,
      });
    }
    materialsUploaded.complete();
  }

  void remove(String materialID)
  {
    materialsUploaded = Completer();

    Firestore.instance.collection('materials').document(materialID).delete();

    materialsUploaded.complete();
  }

  void change(MyMaterial material)
  {
    Firestore.instance.collection('materials').document(material.documentID).updateData(
    {
      'name': material.name,
      'fabric': material.fabric,
    }
    );
    notifyListeners();
  }
}

class MyMaterial
{
  String documentID;
  String name;
  String fabric;
  int count;

  bool operator ==(o) =>
      o is MyMaterial && o.documentID == documentID;

  MyMaterial
  (
    {
      this.documentID,
      this.name,
      this.fabric,
      this.count,
    }
  );
}