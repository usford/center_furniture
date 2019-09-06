
import 'package:flutter/material.dart';
import 'package:furniture_center/global_state.dart';
import 'package:furniture_center/constants.dart';
import 'package:furniture_center/users/workspace_admin.dart';

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
        return WorkSpaceAdmin();
      }
    }
  }
}