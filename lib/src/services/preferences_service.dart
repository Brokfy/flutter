import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = new PreferencesService._internal();

  factory PreferencesService() {
    return _instance;
  }
  PreferencesService._internal();

  SharedPreferences _prefs;
  
  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  resetPrefs() {
    skippedIntro = false;
    isLogged = false;
  }

  get skippedIntro {
    return _prefs.getBool('skippedIntro') ?? false;
  }

  set skippedIntro (bool value) {
    _prefs.setBool('skippedIntro', value);
  }

  get isLogged {
    return _prefs.getBool('isLogged') ?? false;
  }

  set isLogged (bool value) {
    _prefs.setBool('isLogged', value);
  }
}