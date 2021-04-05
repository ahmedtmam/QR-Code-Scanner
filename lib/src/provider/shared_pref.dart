import 'package:shared_preferences/shared_preferences.dart';

class SharedProvider {
  SharedPreferences _pref;

  Future<SharedPreferences> init() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
    return _pref;
  }

  Future<void> setData(String value) async {
    _pref = await init();
    _pref.setString('last', value);
  }

  Future<String> getLastData() async {
    _pref = await init();
    return _pref.getString('last') ?? null;
  }
}
