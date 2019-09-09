
import 'package:furniture_center/Adapters/adapter_users.dart';

class GlobalState
{
  static final GlobalState _globalState = GlobalState._iternal();

  String userType;
  User user;

  factory GlobalState()
  {
    return _globalState;
  }

  GlobalState._iternal(
  {
    this.userType, 
    this.user
  });
}