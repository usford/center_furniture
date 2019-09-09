
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
class AdapterImage with ChangeNotifier
{
  List<MyImage> _images = List<MyImage>();
  AdapterImage()
  {
    Firestore.instance.collection('images').snapshots().listen((snapshotData) async
    {
      if (snapshotData != null)
      {
        snapshotData.documentChanges.forEach((documentChange) async 
        {
          switch(documentChange.type.toString())
          {
            case 'DocumentChangeType.added':
            {
              MyImage myImage = MyImage();
              myImage.documentID = documentChange.document.documentID;
              myImage.path = documentChange.document.data['imagePath'];
              _images.add(myImage);
              notifyListeners();
              break;
            }
          }
        });
      }
    });

   
  }

  List<MyImage> get images
  {
    return _images;
  }
  void add(String path)
  {
    Firestore.instance.collection('images').add({'imagePath': path});
  }
}

class MyImage
{
  String documentID;
  String path;

  MyImage
  (
    {
      this.documentID, 
      this.path
    }
  );
}