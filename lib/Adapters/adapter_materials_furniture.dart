
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:furniture_center/Adapters/adapter_furniture.dart';
import 'package:furniture_center/Adapters/adapter_material.dart';

class AdapterMaterialsFurniture with ChangeNotifier
{
  List<MyMaterial> _materials = List<MyMaterial>();
  Completer materialsUploaded;
  final String furnitureID;
  AdapterMaterialsFurniture({this.furnitureID})
  {
    Firestore.instance.collection('furnitures').document(furnitureID).collection('materials').snapshots().listen((snapshotData) async
    {
      print('4321');
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
              material.count = documentChange.document.data['count'];

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
              _materials.forEach((material)
              {
                if (documentChange.document.documentID == material.documentID)
                {
                  material.name = documentChange.document.data['name'];
                  material.fabric = documentChange.document.data['fabric'];
                  material.count = documentChange.document.data['count'];
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

  void add(Furniture furniture, MyMaterial material)
  {
    materialsUploaded = Completer();
    Firestore.instance.collection('furnitures').document(furniture.documentID).collection('materials').add(
      {
        'materialID': material.documentID,
        'name': material.name,
        'fabric': material.fabric,
        'count': material.count
      }
    );
    materialsUploaded.complete();
  }

  void remove(String materialID, Furniture furniture)
  {
    materialsUploaded = Completer();

    Firestore.instance.collection('furnitures').document(furniture.documentID).collection('materials').document(materialID).delete();

    materialsUploaded.complete();
  }

  void change(Furniture furniture, MyMaterial material, String myID, String materialID)
  {
    materialsUploaded = Completer();
    Firestore.instance.collection('furnitures').document(furniture.documentID).collection('materials').document(myID).setData(
      {
        'materialID': materialID,
        'name': material.name,
        'fabric': material.fabric,
        'count': material.count
      }
    );
    materialsUploaded.complete();
  }

  
}

class MyMaterialFurnitures
{
  String documentID;
  String name;
  String fabric;
  int count;

  bool operator ==(o) =>
      o is MyMaterialFurnitures && o.documentID == documentID;

  MyMaterialFurnitures
  (
    {
      this.documentID,
      this.name,
      this.fabric,
      this.count,
    }
  );
}