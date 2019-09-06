
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_center/global_state.dart';

class AdapterAuthorization with ChangeNotifier
{
  bool _auth = false;
  GlobalState _globalState = GlobalState();

  void checkAuthorization(String email, String password) async
  {
    QuerySnapshot documents = await Firestore.instance.collection('users').getDocuments();

    documents.documents.forEach((doc)
    {
      if (doc.data['email'] == email && doc.data['password'] == password)
      {
        this.auth = true;
        _globalState.userType = doc.data['type'];
        print('Прошёл регистрацию');
      }
    });
  }

  bool get auth {
    return _auth;
  }

  set auth(bool auth) {
    _auth = auth;
    notifyListeners();
  }
}