
import 'package:flutter/material.dart';
import 'package:furniture_center/global_state.dart';
import 'package:furniture_center/constants.dart';
import 'package:furniture_center/users/workspace_admin.dart';
import 'package:furniture_center/users/workspace_client.dart';
import 'package:furniture_center/users/workspace_manager.dart';

class ChooseUser extends StatefulWidget
{
  @override
  _StateChooseUser createState() => _StateChooseUser();
}

class _StateChooseUser extends State<ChooseUser>
{
  GlobalState _globalState = GlobalState();
  @override
  Widget build(BuildContext context)
  {
    switch(_globalState.userType)
    {
      case Constants.admin:
      {
        return MaterialApp
        (
          home: WorkSpaceAdmin(),
        );
      }

      case Constants.client:
      {
        return MaterialApp
        (
          home: WorkspaceClient(),
        );
      }

      case Constants.manager:
      {
        return MaterialApp
        (
          home: WorkSpaceManager(),
        );
      }
    }
  }
}