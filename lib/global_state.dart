
class GlobalState
{
  static final GlobalState _globalState = GlobalState._iternal();

  String userType;

  factory GlobalState()
  {
    return _globalState;
  }

  GlobalState._iternal(
  {
    this.userType, 
  });
}