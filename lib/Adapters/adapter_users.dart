
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdapterUser with ChangeNotifier
{
  List<User> _users = List<User>();
  Completer usersUploaded;

  AdapterUser()
  {
    Firestore.instance.collection('users').snapshots().listen((snapshotData) async
    {
      if (snapshotData != null)
      {
        snapshotData.documentChanges.forEach((documentChange) async 
        {
          switch(documentChange.type.toString())
          {
            case 'DocumentChangeType.added':
            {
              User user = User();
              
              user.documentID = documentChange.document.documentID;
              user.email = documentChange.document.data['email'];
              user.password = documentChange.document.data['password'];
              user.type = documentChange.document.data['type'];

              _users.add(user);
              notifyListeners();

              break;
            }

            case 'DocumentChangeType.removed': 
            {
              _users.remove(User(documentID: documentChange.document.documentID));
              notifyListeners();
              break;
            }

            case 'DocumentChangeType.modified':
            {
              print('Изменено');

              _users.forEach((user)
              {
                if (documentChange.document.documentID == user.documentID)
                {
                  user.type = documentChange.document.data['type'];
                  user.email = documentChange.document.data['email'];
                  user.password = documentChange.document.data['password'];
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

  List<User> get users
  {
    return _users;
  }

  set user(List<User> users)
  {
    _users = users;
  }

  void add(User user)
  {
    usersUploaded = Completer();

    Firestore.instance.collection('users').add(
    {
      'email' : user.email,
      'password': user.password,
      'type': user.type
    });

    usersUploaded.complete();
  }

  void remove(String userID)
  {
    usersUploaded = Completer();

    Firestore.instance.collection('users').document(userID).delete();

    usersUploaded.complete();
  }

  void changeUser(User user)
  {
    print(user.email);
    print(user.type);
    print(user.password);
    Firestore.instance.collection('users').document(user.documentID).updateData(
    {
      'email': user.email,
      'password': user.password,
      'type': user.type
    }
    );
    notifyListeners();
  }
}

class User 
{
  String documentID;
  String type;
  String email;
  String password;

  bool operator ==(o) =>
      o is User && o.documentID == documentID;

  User
  (
    {
      this.documentID,
      this.type,
      this.email,
      this.password
    }
  );
}