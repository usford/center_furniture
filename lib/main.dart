import 'package:flutter/material.dart';
import 'package:furniture_center/Adapters/adapter_authorization.dart';
import 'package:furniture_center/Adapters/adapter_furniture.dart';
import 'package:furniture_center/Adapters/adapter_material.dart';
import 'package:furniture_center/Adapters/adapter_provider.dart';
import 'package:furniture_center/Adapters/adapter_purchase.dart';
import 'package:furniture_center/Adapters/adapter_users.dart';
import 'package:furniture_center/choouse_user.dart';
import 'package:furniture_center/users/workspace_admin.dart';
import 'package:furniture_center/workspace_authorization.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    
    return  MaterialApp
    (
      title: 'Flutter Demo',
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  AdapterFurniture adapterFurniture;
  AdapterMaterial adapterMaterial;
  AdapterProvider adapterProvider;
  AdapterUser adapterUser;
  AdapterPurchase adapterPurchase;

  _MyHomePageState()
  {
    adapterFurniture = AdapterFurniture();
    adapterMaterial = AdapterMaterial();
    adapterProvider = AdapterProvider();
    adapterUser = AdapterUser();
    adapterPurchase = AdapterPurchase();
  }
  @override
  Widget build(BuildContext context) 
  {
    // return MaterialApp
    // (
      
    //   home: ChangeNotifierProvider<AdapterAuthorization>
    //   (
    //     builder: (_) => AdapterAuthorization(),
    //     child: Scaffold
    //     (
          
    //       body: Consumer<AdapterAuthorization>
    //       (
    //         builder: (context, value, child)
    //         {
    //           return (value.auth) ? ChooseUser() : WorkspaceAuthorization();
    //         },
    //       )
    //     ),
    //   )  
    // );
    var providers = <SingleChildCloneableWidget>
    [
      ChangeNotifierProvider<AdapterFurniture>.value(
        value: adapterFurniture,
      ),
      ChangeNotifierProvider<AdapterMaterial>.value(
        value: adapterMaterial,
      ),
      ChangeNotifierProvider<AdapterProvider>.value(
        value: adapterProvider,
      ),
      ChangeNotifierProvider<AdapterUser>.value(
        value: adapterUser,
      ),
      ChangeNotifierProvider<AdapterPurchase>.value(
        value: adapterPurchase,
      ),
    ];
    return MultiProvider
    (
      providers: providers,
      child: WorkSpaceAdmin(),
    );
  }
}
